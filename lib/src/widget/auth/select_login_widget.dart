import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/device_helper/device_helper.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/login_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectLoginWidget extends StatefulWidget {
  const SelectLoginWidget({super.key});

  @override
  State<SelectLoginWidget> createState() => _SelectLoginWidgetState();
}

class _SelectLoginWidgetState extends State<SelectLoginWidget> {
  int index = -1;
  final roles = ["BUSINESS_OWNER", "MANAGER", "WORKER"];

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            height: 4.h,
            width: 56.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: AppColor.greyE5,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              itemButton(AppIcons.owner, "owner".tr(), index == 0, () {
                index = 0;
                setState(() {});
              }),
              SizedBox(width: 12.w),
              itemButton(AppIcons.manager, "manager".tr(), index == 1, () {
                index = 1;
                setState(() {});
              }),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              itemButton(AppIcons.worker, "worker".tr(), index == 2, () {
                index = 2;
                setState(() {});
              }),
            ],
          ),
          SizedBox(height: 10.h),
          AppButton(
            width: double.infinity,
            onTap: () {
              if (index != -1) {
                Navigator.pop(context);
                AppService.changePage(
                  context,
                  BlocProvider(
                    create: (_) => AuthBloc(authRepository: AuthRepository()),
                    child: LoginScreen(role: roles[index].toUpperCase()),
                  ),
                );
              }
            },
            isGradient: index != -1,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget itemButton(String icon, String text, bool select, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: select ? AppColor.yellowEF : AppColor.white,
            border: Border.all(
              width: 1.h,
              color: select ? AppColor.yellowFF : AppColor.greyE5,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1.5),
                blurRadius: 8,
                color: AppColor.black.withValues(alpha: .03),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52.h,
                    width: 52.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColor.greyFA,
                      border: Border.all(width: 1.3.h, color: AppColor.greyE5),
                    ),
                    child: Center(child: AppSvgAsset(icon)),
                  ),
                  Spacer(),
                  Container(
                    height: 20.h,
                    width: 20.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: select ? 4.h : 1.h,
                        color: select ? AppColor.yellowFFC : AppColor.greyE5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(text, style: DeviceHelper.isTablet(context) ? AppTextStyle.f500s12 : AppTextStyle.f500s16),
              Text(
                "secondaryText".tr(),
                style: DeviceHelper.isTablet(context) ? AppTextStyle.f500s10.copyWith(color: AppColor.grey77) : AppTextStyle.f500s14.copyWith(color: AppColor.grey77),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
