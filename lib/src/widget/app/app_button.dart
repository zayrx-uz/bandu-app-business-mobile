import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final double? height, width, radius;
  final Color? backColor, borderColor, txtColor, leftIconColor, rightIconColor;
  final String? text;
  final Widget? child;
  final List<BoxShadow>? shadow;
  final bool isGradient, loading;
  final Border? border;
  final TextStyle? style;
  final EdgeInsets? margin;
  final String? rightIcon, leftIcon;
  final Function() onTap;

  const AppButton({
    super.key,
    this.height,
    this.width,
    this.backColor,
    this.borderColor,
    this.text,
    this.child,
    this.shadow,
    this.style,
    this.radius,
    this.isGradient = true,
    this.loading = false,
    this.border,
    this.margin,
    this.rightIcon,
    this.leftIconColor,
    this.rightIconColor,
    this.leftIcon,
    required this.onTap,
    this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        height: height ?? 48.h,
        width: width ?? MediaQuery.of(context).size.width,
        margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: !isGradient ? null : AppColor.buttonGradient,
          color: backColor,
          borderRadius: BorderRadius.circular(radius ?? 12.r),
          border: border,
          boxShadow:
              shadow ??
              [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: AppColor.black0D.withValues(alpha: .06),
                ),
              ],
        ),
        child: loading
            ? Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColor.white,
                ),
              )
            : child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leftIcon != null)
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          child: AppSvgAsset(leftIcon!, color: leftIconColor),
                        ),
                      Text(
                        text ?? "Login",
                        style:
                            style ??
                            AppTextStyle.f600s16.copyWith(
                              color: txtColor ?? AppColor.white,
                            ),
                      ),
                      if (rightIcon != null)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          child: AppSvgAsset(rightIcon!, color: rightIconColor),
                        ),
                    ],
                  ),
      ),
    );
  }
}
