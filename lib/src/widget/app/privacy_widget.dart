import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
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
              text: "By Login or Register, you agree to our",
              style: AppTextStyle.f400s12.copyWith(color: AppColor.grey71 , fontSize:  isTablet(context) ? 8.sp : 12.sp),
            ),
            TextSpan(
              text: " Service Agreement ",
              recognizer: TapGestureRecognizer()..onTap = () {},
              style: AppTextStyle.f400s12.copyWith(color: AppColor.black09 , fontSize: isTablet(context) ? 8.sp : 12.sp),
            ),
            TextSpan(
              text: "and ",
              style: AppTextStyle.f400s12.copyWith(color: AppColor.grey71 , fontSize: isTablet(context) ? 8.sp : 12.sp),
            ),
            TextSpan(
              text: "Terms and Conditions.",
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
