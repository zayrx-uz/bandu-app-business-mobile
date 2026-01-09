import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/employer/screen/edit_employee_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployerItemWidget extends StatefulWidget {
  final EmployeeItemData data;

  const EmployerItemWidget({super.key, required this.data});

  @override
  State<EmployerItemWidget> createState() => _EmployerItemWidgetState();
}

class _EmployerItemWidgetState extends State<EmployerItemWidget>
    with SingleTickerProviderStateMixin {
  bool open = false;

  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void toggle() {
    setState(() {
      open = !open;
      open ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EmployeeItemData data = widget.data;
    return GestureDetector(
      onTap: toggle,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.white,
          border: Border.all(width: 1.h, color: AppColor.greyE5),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(isTablet(context) ? 6.w : 12.w),
              child: Row(
                children: [
                  CustomNetworkImage(
                    imageUrl: data.profilePicture,
                    height: 48.h,
                    width: 48.h,
                    borderRadius: 100,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.fullName,
                          maxLines: 1,
                          style: AppTextStyle.f500s16.copyWith(
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                        Text(
                          data.role.toUpperCase(),
                          style: AppTextStyle.f400s14.copyWith(
                            color: AppColor.grey58,
                            fontSize: isTablet(context) ? 10.sp : 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  RotationTransition(
                    turns: _rotateAnimation,
                    child: AppIconButton(icon: AppIcons.bottom, onTap: toggle),
                  ),
                ],
              ),
            ),

            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  children: [
                    Divider(height: 1, color: AppColor.greyE5),

                    SizedBox(height: 12.h),

                    _rowItem(
                      "phoneNumber".tr(),
                      data.authProviders.first.phoneNumber.phoneFormat(),
                    ),

                    SizedBox(height: isTablet(context) ? 8.h : 12.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Text(
                            "contactStatus".tr(),
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.grey58,
                              fontSize: isTablet(context) ? 12.sp : 16.sp,
                            ),
                          ),
                          SizedBox(width: 32.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: AppColor.black,
                            ),
                            child: Text(
                              data.role,
                              style: AppTextStyle.f500s14.copyWith(
                                color: AppColor.white,
                                fontSize: isTablet(context) ? 10.sp : 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),
                    Divider(height: 1, color: AppColor.greyE5),
                    SizedBox(height: 12.h),

                    BlocConsumer<HomeBloc, HomeState>(
                      listenWhen: (prev, cur) {
                        return prev != cur;
                      },
                      listener: (context, state) {
                        if (state is DeleteEmployeeSuccessState) {
                          AppService.successToast(context, "success".tr());
                          BlocProvider.of<HomeBloc>(
                            context,
                          ).add(GetEmployeeEvent());
                        }
                        if (state is HomeErrorState) {
                          CenterDialog.errorDialog(context, state.message);
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                        'tel:${data.authProviders.first.phoneNumber.phoneFormat()}',
                                      ),
                                    );
                                  },
                                  height: 40.h,
                                  isGradient: false,
                                  backColor: AppColor.white,
                                  margin: EdgeInsets.zero,
                                  text: "callPerson".tr(),
                                  txtColor: AppColor.black,
                                  leftIcon: AppIcons.call,
                                  border: Border.all(
                                    width: 1.h,
                                    color: AppColor.greyE5,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              AppIconButton(
                                icon: AppIcons.edit2,
                                onTap: () {
                                  CupertinoScaffold.showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return BlocProvider(
                                        create: (_) => HomeBloc(
                                          homeRepository: HomeRepository(),
                                        ),
                                        child: UpdateEmployeeScreen(
                                          data: widget.data,
                                        ),
                                      );
                                    },
                                  ).then((on) {
                                    BlocProvider.of<HomeBloc>(
                                      context,
                                    ).add(GetEmployeeEvent());
                                  });
                                },
                                iconColor: Colors.white,
                                backColor: Colors.orange,
                                height: 40.h,
                                width: 40.h,
                              ),
                              SizedBox(width: 4.w),
                              AppIconButton(
                                loading: state is DeleteEmployeeLoadingState,
                                icon: AppIcons.delete,
                                onTap: () {
                                  BlocProvider.of<HomeBloc>(
                                    context,
                                  ).add(DeleteEmployeeEvent(widget.data.id));
                                },
                                iconColor: Colors.white,
                                backColor: Colors.red,
                                height: 40.h,
                                width: 40.h,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyle.f400s16.copyWith(
              color: AppColor.grey58,
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          SizedBox(width: 32.w),
          Text(
            value,
            style: AppTextStyle.f400s16.copyWith(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
