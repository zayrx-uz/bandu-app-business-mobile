import 'dart:convert';

import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart' hide Image;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/app/unfocus_keyboard_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:flutter/services.dart';
import 'package:bandu_business/src/widget/main/settings/resource/select_resource_item.dart';
import 'package:bandu_business/src/widget/main/settings/resource/select_type_item.dart';
import 'package:bandu_business/src/widget/main/settings/resource/select_employee_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'create_resource_screen.dart';

class EditResourceScreen extends StatefulWidget {
  final Datum resourceData;
  const EditResourceScreen({super.key, required this.resourceData});

  @override
  State<EditResourceScreen> createState() => _EditResourceScreenState();
}

class _EditResourceScreenState extends State<EditResourceScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController timeSlotController;
  late int selectedCategoryId;
  late bool isBookable;
  late bool isTimeSlotBased;
  late int timeSlotDurationMinutes;
  List<Map<String, dynamic>> uploadedImages = [];
  List<int> selectedEmployeeIds = [];
  List<int> replacedImageIds = [];

  XFile? img;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeData();
    getData();
  }

  void _initializeData() {
    nameController = TextEditingController(text: widget.resourceData.name);
    priceController = TextEditingController(text: widget.resourceData.price.formatWithSpaces());
    selectedCategoryId = widget.resourceData.resourceCategory?.id ?? -1;
    isBookable = widget.resourceData.isBookable;
    isTimeSlotBased = widget.resourceData.isTimeSlotBased;
    timeSlotDurationMinutes = widget.resourceData.timeSlotDurationMinutes;
    
    if (timeSlotDurationMinutes > 0) {
      int hours = timeSlotDurationMinutes ~/ 60;
      int minutes = timeSlotDurationMinutes % 60;
      timeSlotController = TextEditingController(
        text: "$hours ${"hours".tr()} $minutes ${"minutesShort".tr()}"
      );
    } else {
      timeSlotController = TextEditingController();
    }

    if (widget.resourceData.images.isNotEmpty) {
      uploadedImages = widget.resourceData.images.map((image) {
        return {
          "id": image.id,
          "url": image.url,
          "index": image.index,
          "isMain": image.isMain,
        };
      }).toList();
      _networkImageUrl = widget.resourceData.images.firstWhere(
        (img) => img.isMain,
        orElse: () => widget.resourceData.images.first,
      ).url;
    }

    if (widget.resourceData.businessUsers.isNotEmpty) {
      selectedEmployeeIds = widget.resourceData.businessUsers.map((e) => e.id).toList();
    } else if (widget.resourceData.metadata != null) {
      Map<String, dynamic>? metadata;
      if (widget.resourceData.metadata is Map) {
        metadata = widget.resourceData.metadata as Map<String, dynamic>;
      } else if (widget.resourceData.metadata is String) {
        try {
          final decoded = jsonDecode(widget.resourceData.metadata as String);
          if (decoded is Map) {
            metadata = Map<String, dynamic>.from(decoded);
          }
        } catch (e) {
        }
      }
      
      if (metadata != null && metadata.containsKey('employeeIds') && metadata['employeeIds'] is List) {
        final employeeIdsList = metadata['employeeIds'] as List;
        selectedEmployeeIds = employeeIdsList.map((e) {
          if (e is int) return e;
          if (e is String) return int.tryParse(e) ?? 0;
          return 0;
        }).where((e) => e > 0).toList();
      }
    }
  }

  void getData() {
    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0) {
      context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
      context.read<HomeBloc>().add(GetEmployeeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusKeyboard(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetImageSuccessState) {
            setState(() => img = state.img);
            if (img != null) {
              context.read<HomeBloc>().add(UploadResourceImageEvent(filePath: img!.path));
            }
          }
          if (state is UploadResourceImageSuccessState) {
            setState(() {
              if (uploadedImages.isNotEmpty) {
                final firstImage = uploadedImages.first;
                final updatedImage = <String, dynamic>{
                  "url": state.url,
                  "index": firstImage['index'] ?? 1,
                  "isMain": true,
                };
                if (firstImage.containsKey('id') && firstImage['id'] != null && firstImage['id'] != 0) {
                  final id = firstImage['id'] is int ? firstImage['id'] as int : int.tryParse(firstImage['id'].toString()) ?? 0;
                  updatedImage["id"] = id;
                  if (id > 0 && !replacedImageIds.contains(id)) {
                    replacedImageIds = [...replacedImageIds, id];
                  }
                }
                uploadedImages = [updatedImage, ...uploadedImages.sublist(1)];
              } else {
                uploadedImages = [<String, dynamic>{
                  "url": state.url,
                  "index": 1,
                  "isMain": true,
                }];
              }
              _networkImageUrl = state.url;
            });
          }
          if (state is EditResourceSuccessState) {
            CenterDialog.successDialog(
              context,
              "success".tr(),
              () {
                Navigator.of(context).pop(true);
              },
            );
          }
          if (state is HomeErrorState) {
            CenterDialog.errorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          bool loading = state is EditResourceLoadingState ||
              state is UploadResourceImageLoadingState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(
                isAppName: false,
                text: "editResource".tr(),
                isBack: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      SetImageWidget(
                        isHome: true,
                        img: img,
                        networkImage: _networkImageUrl,
                      ),
                      SizedBox(height: 20.h),
                      SelectResourceWidget(
                        initialCategoryId: selectedCategoryId > 0 ? selectedCategoryId : null,
                        onCategorySelected: (categoryId) {
                          setState(() {
                            selectedCategoryId = categoryId;
                          });
                        },
                      ),
                      SizedBox(height: 12.h),
                      InputWidget(
                        controller: nameController,
                        title: "resourceName".tr(),
                        hint: "resourceNameHint".tr(),
                      ),
                      SizedBox(height: 12.h),
                      InputWidget(
                        controller: priceController,
                        inputType: TextInputType.number,
                        title: "price".tr(),
                        hint: "priceHint".tr(),
                        format: [
                          FilteringTextInputFormatter.digitsOnly,
                          ThousandsFormatter(),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SelectTypeWidget(
                        onTap: (v) {
                          setState(() {
                            isBookable = v;
                          });
                        },
                        isAvaible: isBookable,
                      ),
                      SizedBox(height: 12.h),
                      SelectEmployeeWidget(
                        initialSelectedIds: selectedEmployeeIds,
                        onEmployeesSelected: (ids) {
                          setState(() {
                            selectedEmployeeIds = ids;
                          });
                        },
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "resourceTimeDate".tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black09,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: () => _showTimeSlotPicker(context),
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 48.h,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: AppColor.greyFA,
                                  border: Border.all(width: 1.h, color: AppColor.greyE5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        timeSlotController.text.isNotEmpty 
                                            ? timeSlotController.text 
                                            : "select".tr(),
                                        style: TextStyle(
                                          color: timeSlotController.text.isNotEmpty 
                                              ? AppColor.black09 
                                              : AppColor.grey77,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    GestureDetector(
                                      onTap: () => _showTimeSlotPicker(context),
                                      child: AppSvgAsset(
                                        AppIcons.clock,
                                        height: 20.h,
                                        width: 20.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              AppButton(
                onTap: () {
                  if (nameController.text.isEmpty) {
                    CenterDialog.errorDialog(context, "pleaseEnterResourceName".tr());
                    return;
                  }
                  if (selectedCategoryId == -1) {
                    CenterDialog.errorDialog(context, "pleaseSelectCategory".tr());
                    return;
                  }
                  if (priceController.text.isEmpty) {
                    CenterDialog.errorDialog(context, "pleaseEnterPrice".tr());
                    return;
                  }
                  final companyId = HelperFunctions.getCompanyId() ?? 0;
                  if (companyId == 0) {
                    CenterDialog.errorDialog(context, "companyNotSelected".tr());
                    return;
                  }
                  
                  final priceValue = int.tryParse(priceController.text.replaceAll(" ", "")) ?? 0;
                  if (priceValue == 0) {
                    CenterDialog.errorDialog(context, "pleaseEnterPrice".tr());
                    return;
                  }
                  
                  context.read<HomeBloc>().add(EditResourceEvent(
                    id: widget.resourceData.id,
                    name: nameController.text,
                    companyId: companyId,
                    price: priceValue,
                    resourceCategoryId: selectedCategoryId,
                    isBookable: isBookable,
                    isTimeSlotBased: isTimeSlotBased,
                    timeSlotDurationMinutes: timeSlotDurationMinutes,
                    images: uploadedImages,
                    employeeIds: selectedEmployeeIds.isNotEmpty ? selectedEmployeeIds : null,
                    replacedImageIds: replacedImageIds.isNotEmpty ? replacedImageIds : null,
                  ));
                },
                leftIcon: AppIcons.edit2,
                leftIconColor: Colors.white,
                loading: loading,
                text: "save".tr(),
              ),
              SizedBox(height: 24.h),
            ],
          );
        },
      ),
      ),
    );
  }

  void _showTimeSlotPicker(BuildContext context) {
    int hours = timeSlotDurationMinutes ~/ 60;
    int minutes = timeSlotDurationMinutes % 60;
    int selectedHours = hours.clamp(0, 100);
    int selectedMinutesIndex = (minutes ~/ 5).clamp(0, 11);
    int selectedMinutes = selectedMinutesIndex * 5;
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    topLeft: Radius.circular(20.r),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.greyE5,
                              width: 1.h,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "selectTime".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black09,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                size: 24.sp,
                                color: AppColor.black09,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 250.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(initialItem: selectedHours),
                                itemExtent: 50.h,
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedHours = index;
                                  });
                                },
                                children: List<Widget>.generate(101, (int index) {
                                  return Center(
                                    child: Text(
                                      index.toString(),
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.black09,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Text(
                                "hours".tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.grey77,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              flex: 2,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(initialItem: selectedMinutesIndex),
                                itemExtent: 50.h,
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedMinutesIndex = index;
                                    selectedMinutes = index * 5;
                                  });
                                },
                                children: List<Widget>.generate(12, (int index) {
                                  return Center(
                                    child: Text(
                                      (index * 5).toString(),
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.black09,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Text(
                                "minutesShort".tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.grey77,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        child: AppButton(
                          onTap: () {
                            int totalMinutes = selectedHours * 60 + selectedMinutes;
                            
                            setState(() {
                              if (totalMinutes == 0) {
                                isTimeSlotBased = false;
                                timeSlotDurationMinutes = 0;
                                timeSlotController.text = "";
                              } else {
                                String timeText = "$selectedHours ${"hours".tr()} $selectedMinutes ${"minutesShort".tr()}";
                                isTimeSlotBased = true;
                                timeSlotDurationMinutes = totalMinutes;
                                timeSlotController.text = timeText;
                              }
                            });
                            Navigator.pop(context);
                          },
                          text: "save".tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    timeSlotController.dispose();
    super.dispose();
  }
}
