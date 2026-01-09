import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/register_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/privacy_widget.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      // appBar: AppBar(backgroundColor: AppColor.white, title: TopAppName()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: isTablet(context) ? 30.h : 40.h,),
            TopAppName(),
            Image.asset(
              AppImages.onb,
              height: 358.h,
              fit : BoxFit.cover
            ),
            SizedBox(height: 12.h),
            Text("exclusiveServices".tr(), style: AppTextStyle.f600s24.copyWith(
              fontSize: isTablet(context) ? 18.sp : 24.sp
            )),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "redeemPointsDescription".tr(),
                style: AppTextStyle.f400s16.copyWith(color: AppColor.greyA7 , fontSize: isTablet(context) ? 12.sp : 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            AppButton(
              onTap: () {
                BottomDialog.selectLogin(context);
              },
              margin: isTablet(context) ? EdgeInsets.symmetric(horizontal: 50.w) : EdgeInsets.symmetric(horizontal: 20.w),
              text: "login".tr(),
            ),
            SizedBox(height: 12.h),
            AppButton(
              onTap: () {
                AppService.changePage(context, RegisterScreen());
              },
              text: "register".tr(),
              style: AppTextStyle.f600s16.copyWith(
                 fontSize:  isTablet(context) ? 12.sp : 16.sp
              ),
              isGradient: false,
              backColor: AppColor.white,

              margin: isTablet(context) ? EdgeInsets.symmetric(horizontal: 50.w) : EdgeInsets.symmetric(horizontal: 20.w),
              border: Border.all(width: 1.h, color: AppColor.greyE5),
            ),
            SizedBox(height: 24.h),
            PrivacyWidget(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}



bool isTablet(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  return width >= 600;
}