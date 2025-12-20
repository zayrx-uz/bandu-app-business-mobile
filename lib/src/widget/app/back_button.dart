import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtons extends StatelessWidget {
  final EdgeInsets? margin;

  const BackButtons({super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Bounce(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 40.h,
          width: 40.h,
          margin: margin ?? EdgeInsets.only(left: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColor.white,
            border: Border.all(width: 1.h, color: AppColor.greyE5),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: AppColor.black0D.withValues(alpha: .06),
              ),
            ],
          ),
          child: Center(child: AppSvgAsset(AppIcons.back)),
        ),
      ),
    );
  }
}
