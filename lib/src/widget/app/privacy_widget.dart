import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyWidget extends StatelessWidget {
  const PrivacyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "byLoginOrRegister".tr(),
              style: AppTextStyle.f400s12.copyWith(color: AppColor.grey71 , fontSize:  isTablet(context) ? 8.sp : 12.sp),
            ),
            TextSpan(
              text: "serviceAgreement".tr(),
              recognizer: TapGestureRecognizer()..onTap = () {},
              style: AppTextStyle.f400s12.copyWith(color: AppColor.black09 , fontSize: isTablet(context) ? 8.sp : 12.sp),
            ),
            TextSpan(
              text: "and".tr(),
              style: AppTextStyle.f400s12.copyWith(color: AppColor.grey71 , fontSize: isTablet(context) ? 8.sp : 12.sp),
            ),
            TextSpan(
              text: "termsAndConditions".tr(),
              recognizer: TapGestureRecognizer()..onTap = () {},
              style: AppTextStyle.f400s12.copyWith(
                color: AppColor.black09,
              fontSize:   isTablet(context) ? 8.sp : 12.sp,
                height: 1.4.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
