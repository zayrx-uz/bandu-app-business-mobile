import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../ui/onboard/onboard_screen.dart';

class SettingsButtonWidget extends StatelessWidget {
  final String icon;
  final String text;
  final EdgeInsets? margin;
  final bool isLogout;
  final Function() onTap;

  const SettingsButtonWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.margin,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,

      child: Container(
        height: 60.h,
        width: MediaQuery.of(context).size.width,
        margin: margin ?? EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.white,
          border: Border.all(width: 1.h, color: AppColor.greyF4),
        ),
        child: Row(

          children: [
            Container(
              height: 36.h,
              width: 36.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: isLogout ? AppColor.redFF : AppColor.greyFA,
                border: Border.all(
                  width: 1.h,
                  color: isLogout ? AppColor.redED : AppColor.greyF4,
                ),
              ),
              child: Center(child: AppSvgAsset(icon , width: isTablet(context) ? 16.sp : 20.sp,color : isLogout ? AppColor.redED : AppColor.black)),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(text, style: AppTextStyle.f500s16.copyWith(
               fontSize:  isTablet(context) ? 12.sp : 16.sp
            ))),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColor.greyFA,
                    border: Border.all(width: 1.h, color: AppColor.greyE5),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: AppColor.black0D.withValues(alpha: .06),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AppSvgAsset(AppIcons.right, color: AppColor.black0D),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
