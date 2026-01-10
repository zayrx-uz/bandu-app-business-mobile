import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:flutter/services.dart';
import 'package:bandu_business/src/widget/main/settings/resource/select_resource_item.dart';
import 'package:bandu_business/src/widget/main/settings/resource/select_type_item.dart';
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
  int timeSlotDurationMinutes = 60;
  List<Map<String, dynamic>> uploadedImages = [];
  
  XFile? img;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0) {
      context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              uploadedImages.add({
                "url": state.url,
                "index": uploadedImages.length + 1,
                "isMain": uploadedImages.isEmpty,
              });
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
                        title: "price".tr(),
                        hint: "priceHint".tr(),
                        format: [FilteringTextInputFormatter.digitsOnly],
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
                  context.read<HomeBloc>().add(CreateResourceEvent(
                    name: nameController.text,
                    companyId: companyId,
                    price: int.tryParse(priceController.text) ?? 0,
                    resourceCategoryId: selectedCategoryId,
                    isBookable: isBookable,
                    isTimeSlotBased: isTimeSlotBased,
                    timeSlotDurationMinutes: timeSlotDurationMinutes,
                    images: uploadedImages,
                  ));
                },
                leftIcon: AppIcons.plus,
                leftIconColor: Colors.white,
                loading: loading,
                text: "save".tr(),
              ),
              SizedBox(height: 24.h),
            ],
          );
        },
      ),
    );
  }

  void _showTimeSlotPicker(BuildContext context) {
    int hours = timeSlotDurationMinutes ~/ 60;
    int minutes = timeSlotDurationMinutes % 60;
    int selectedHours = hours.clamp(0, 100);
    int selectedMinutes = minutes.clamp(0, 100);
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.r),
                  topLeft: Radius.circular(20.r),
                ),
              ),
              height: 400.h,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 100.w,),
                        Expanded(
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
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Expanded(
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
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(width: 100.w,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AppButton(
                      onTap: () {
                        int totalMinutes = selectedHours * 60 + selectedMinutes;
                        if (totalMinutes == 0) {
                          totalMinutes = 60;
                        }
                        
                        String timeText = "$selectedHours ${"hours".tr()} $selectedMinutes ${"minutesShort".tr()}";
                        
                        setState(() {
                          isTimeSlotBased = true;
                          timeSlotDurationMinutes = totalMinutes;
                          timeSlotController.text = timeText;
                        });
                        Navigator.pop(context);
                      },
                      text: "save".tr(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
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
