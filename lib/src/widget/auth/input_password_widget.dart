
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bounce/bounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputPasswordWidget extends StatefulWidget {
  final String? title;
  final String? hint;
  final String? trailingMessage;
  final ValueChanged<String>? onChange;


  final TextEditingController controller;

  const InputPasswordWidget({
    super.key,
    this.title,
    required this.controller,
    this.hint, this.trailingMessage,  this.onChange,
  });

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  bool isView = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet(context) ? 30.sp : 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? "password".tr(),
                      style: AppTextStyle.f500s16.copyWith(
                          fontSize : isTablet(context) ? 12.sp : 16.sp
                      ),
                    ),
                  ),

                ],
              ),
              if (widget.trailingMessage != null)
                Text(
                  widget.trailingMessage!,
                  style: AppTextStyle.f400s12.copyWith(color: AppColor.redED),
                ),
            ],
          ),
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
                    onChanged: widget.onChange,
                    cursorColor: Colors.grey,
                    controller: widget.controller,
                    obscureText: isView,
                    style: AppTextStyle.f500s16.copyWith(
                      color: AppColor.black09,
                      fontSize:  isTablet(context) ? 12.sp : 16.sp
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hint ?? "enterPassword".tr(),
                      hintStyle: AppTextStyle.f400s16.copyWith(
                        color: AppColor.grey77,
                        fontSize:   isTablet(context) ? 12.sp : 16.sp
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
                  child: AppSvgAsset(isView ? AppIcons.eyeOff : AppIcons.eye),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
