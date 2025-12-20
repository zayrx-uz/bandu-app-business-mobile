
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputPasswordWidget extends StatefulWidget {
  final String? title;
  final String? hint;

  final TextEditingController controller;

  const InputPasswordWidget({
    super.key,
    this.title,
    required this.controller,
    this.hint,
  });

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  bool isView = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title ?? "Password", style: AppTextStyle.f500s16),
          SizedBox(height: 8.h),
          Container(
            height: 48.h,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColor.greyFA,
              border: Border.all(width: 1.h, color: AppColor.greyE5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    obscureText: isView,
                    style: AppTextStyle.f500s16.copyWith(
                      color: AppColor.black09,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hint ?? "Enter Password",
                      hintStyle: AppTextStyle.f400s16.copyWith(
                        color: AppColor.grey77,
                      ),
                    ),
                  ),
                ),
                Bounce(
                  onTap: () {
                    setState(() {
                      isView = !isView;
                    });
                  },
                  child: AppSvgAsset(AppIcons.eyeOff),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
