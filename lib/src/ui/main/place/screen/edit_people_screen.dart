import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditPlaceScreen extends StatefulWidget {
  const EditPlaceScreen({super.key, required this.id, this.number, required this.name});
  final int id;
  final int? number;
  final String name;

  @override
  State<EditPlaceScreen> createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  bool isActive = false;
  int number = 0;
  String? selectedItem;
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
    super.initState();
    number = widget.number ?? 0;
    if (number > 0) {
      int index = n.indexOf(number);
      if (index != -1) {
        selectedItem = item[index];
      }
    }
    nameController.addListener(check);
  }

  void check() {
    isActive = nameController.text.trim().length >= 3 && number != 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (prev , cur){
        return prev != cur;
      },
      listener: (context, state) {
        if (state is UpdatePlaceSuccessState) {
          AppService.successToast(context, "placeUpdated".tr());
          Navigator.pop(context);
        }

        if (state is DeletePlaceSuccessState) {
          AppService.successToast(context, "placeDeleted".tr());
          Navigator.pop(context);
        }
        if(state is HomeErrorState){
          CenterDialog.errorDialog(context, state.message);
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
                          child: Text("${"editPlace".tr()} (${widget.name})", style: AppTextStyle.f600s18),
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
                      initialItem: selectedItem,
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
                  CacheService.getString("user_role") == "BUSINESS_OWNER" ||  CacheService.getString("user_role") == "MANAGER"  ? Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onTap: () {
                            if (number != 0) {
                              BlocProvider.of<HomeBloc>(context).add(
                                UpdatePlaceEvent(
                                  id: widget.id,
                                  number: number,
                                ),
                              );
                            }
                          },
                          text: "edit".tr(),
                          loading: state is UpdatePlaceLoadingState,
                          txtColor:
                          number != 0 ? AppColor.white : AppColor.greyA7,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: (){
                          BlocProvider.of<HomeBloc>(context).add(
                            DeletePlaceEvent(
                              id: widget.id,
                            ),
                          );
                        },
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: state is DeletePlaceLoadingState ? CupertinoActivityIndicator() : SvgPicture.asset(
                              AppIcons.trash,
                              width: 24.w,
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w)
                    ],
                  ) : SizedBox(),
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