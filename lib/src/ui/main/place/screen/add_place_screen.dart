import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  bool isActive = false;
  int number = 0;
  var n = [1, 2, 4, 6, 8, 12];
  List<String> get item => [
    "1 ${"people".tr()}",
    "2 ${"people".tr()}",
    "4 ${"people".tr()}",
    "6 ${"people".tr()}",
    "8 ${"people".tr()}",
    "12 ${"people".tr()}",
  ];
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.addListener(check);
    super.initState();
  }

  void check() {
    isActive = nameController.text.trim().length >= 3 && number != 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is SetPlaceSuccessState) {
          AppService.successToast(context, "placeCreated".tr());
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Material(
          child: GestureDetector(
            onTap: () {
              AppService.closeKeyboard(context);
            },
            child: Container(
              color: AppColor.white,
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("addPlace".tr(), style: AppTextStyle.f600s18),
                        ),
                        AppIconButton(
                          icon: AppIcons.close,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 0.5.h,
                    width: MediaQuery.of(context).size.width,
                    color: AppColor.greyE5,
                  ),
                  SizedBox(height: 20.h),
                  InputWidget(
                    controller: nameController,
                    title: "placeName".tr(),
                    hint: "placeName".tr(),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "numberOfPeople".tr(),
                      style: AppTextStyle.f500s16.copyWith(
                        color: AppColor.black09,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: DropdownFlutter<String>(
                      hintText: "enterNumber".tr(),
                      excludeSelected: false,
                      hideSelectedFieldWhenExpanded: true,
                      canCloseOutsideBounds: false,
                      decoration: CustomDropdownDecoration(
                        closedFillColor: AppColor.greyFA,
                        expandedFillColor: AppColor.white,
                        listItemStyle: AppTextStyle.f500s16,
                        headerStyle: AppTextStyle.f500s16,
                        closedSuffixIcon: AppSvgAsset(AppIcons.bottom),
                        expandedSuffixIcon: Container(),
                        closedBorder: Border.all(
                          width: 1.h,
                          color: AppColor.greyE5,
                        ),
                      ),
                      items: item,
                      listItemBuilder: (a, b, s, d) {
                        return Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Container(
                                height: 16.h,
                                width: 16.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.greyFA,
                                  border: Border.all(
                                    width: s ? 4.h : 1.h,
                                    color: s
                                        ? AppColor.yellowFFC
                                        : AppColor.greyE5,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(b, style: AppTextStyle.f500s16),
                              ),
                            ],
                          ),
                        );
                      },
                      onChanged: (value) {
                        number = n[item.indexWhere((e) => e == value)];
                        check();
                      },
                    ),
                  ),
                  Spacer(),

                  AppButton(
                    onTap: () {
                      if (isActive) {
                        BlocProvider.of<HomeBloc>(context).add(
                          SetPlaceEvent(
                            name: nameController.text,
                            number: number,
                          ),
                        );
                      }
                    },
                    isGradient: isActive,
                    backColor: AppColor.greyE5,
                    text: "addPlace".tr(),
                    leftIcon: AppIcons.plus,
                    loading: state is SetPlaceLoadingState,
                    txtColor: isActive ? AppColor.white : AppColor.greyA7,
                    leftIconColor: isActive ? AppColor.white : AppColor.greyA7,
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
