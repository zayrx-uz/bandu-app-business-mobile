import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIconButton extends StatelessWidget {
  final String icon;
  final double? height, width, borderRadius;
  final Color? backColor, iconColor;
  final bool? loading;
  final Function() onTap;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.height,
    this.width,
    this.borderRadius,
    this.backColor,
    this.iconColor,
    this.loading,

  });

  @override
  Widget build(BuildContext context) {
    final isLoading = loading != null && loading!;
    return CupertinoButton(
      onPressed: isLoading ? null : onTap,
      padding: EdgeInsets.zero,
      child: Container(
        height: height ?? 32.h,
        width: width ?? 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          color: backColor ?? AppColor.white,
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
          child: isLoading 
              ? CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    iconColor ?? AppColor.black,
                  ),
                )
              : AppSvgAsset(icon, color: iconColor ?? AppColor.black),
        ),
      ),
    );
  }
}
