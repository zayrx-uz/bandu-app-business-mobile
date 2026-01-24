import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
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

class CreateResourceScreen extends StatefulWidget {
  final int? companyId;
  const CreateResourceScreen({super.key, this.companyId});

  @override
  State<CreateResourceScreen> createState() => _CreateResourceScreenState();
}

class _CreateResourceScreenState extends State<CreateResourceScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timeSlotController = TextEditingController();
  int selectedCategoryId = -1;
  bool isBookable = true;
  bool isTimeSlotBased = false;
  int timeSlotDurationMinutes = 0;
  List<Map<String, dynamic>> uploadedImages = [];
  List<int> selectedEmployeeIds = [];

  XFile? img;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    getData();
    nameController.addListener(() => setState(() {}));
    priceController.addListener(() => setState(() {}));
  }

  void getData() {
    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0) {
      context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
      context.read<HomeBloc>().add(GetEmployeeEvent());
    }
  }

  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        selectedCategoryId != -1 &&
        priceController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusKeyboard(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetImageSuccessState) {
            setState(() {
              img = state.img;
            });
            if (img != null) {
              context.read<HomeBloc>().add(UploadResourceImageEvent(filePath: img!.path));
            }
          }
          if (state is UploadResourceImageSuccessState) {
            setState(() {
              final newImage = <String, dynamic>{
                "url": state.url,
                "index": uploadedImages.length + 1,
                "isMain": uploadedImages.isEmpty,
              };
              uploadedImages = [...uploadedImages, newImage];
              _networkImageUrl = state.url;
            });
          }
          if (state is CreateResourceSuccessState) {
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
          bool loading = state is CreateResourceLoadingState ||
              state is UploadResourceImageLoadingState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(
                isAppName: false,
                text: "createResource".tr(),
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
                            Row(
                              children: [
                                Text(
                                  "resourceTimeDate".tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black09,
                                  ),
                                ),
                              ],
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
                      SizedBox(height: 12.h),
                      AppButton(
                        onTap: () {
                          if (!isFormValid) {
                            return;
                          }
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
                          print(int.parse(priceController.text.replaceAll(" ", "")));
                          context.read<HomeBloc>().add(CreateResourceEvent(
                            name: nameController.text,
                            companyId: companyId,
                            price: int.parse(priceController.text.replaceAll(" ", "")),
                            resourceCategoryId: selectedCategoryId,
                            isBookable: isBookable,
                            isTimeSlotBased: timeSlotDurationMinutes != 0 ,
                            timeSlotDurationMinutes: timeSlotDurationMinutes,
                            images: uploadedImages,
                            employeeIds: selectedEmployeeIds.isNotEmpty ? selectedEmployeeIds : null,
                          ));
                        },
                        leftIcon: AppIcons.plus,
                        leftIconColor: Colors.white,
                        loading: loading,
                        text: "save".tr(),
                        isGradient: isFormValid,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
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
    int selectedMinutes = minutes.clamp(0, 59);

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
                            SizedBox(width: 24.w,),
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
                                scrollController: FixedExtentScrollController(initialItem: selectedMinutes),
                                itemExtent: 50.h,
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedMinutes = index;
                                  });
                                },
                                children: List<Widget>.generate(60, (int index) {
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

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(' ', '');

    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[text.length - i - 1]);
      if ((i + 1) % 3 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString().split('').reversed.join();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}