import 'package:bandu_business/src/helper/no_emoji_input_formatter.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final String? rightIcon;
  final List<TextInputFormatter>? format;
  final VoidCallback? onRightIconTap;
  final bool readOnly;
  final  TextInputType? inputType;
  final FocusNode? focusNode;

  const InputWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.rightIcon,
    this.format,
    this.onRightIconTap,
    this.readOnly = false, 
    this.inputType,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.f500s16.copyWith(color: AppColor.black09 , fontSize: isTablet(context) ? 12.sp : 16.sp),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 48.h,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
              border: Border.all(width: 1.h, color: AppColor.greyE5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    keyboardType: inputType,
                    cursorColor: Colors.grey,
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller,
                    inputFormatters: [
                      NoEmojiInputFormatter(),
                      ...?format,
                    ],
                    onSubmitted: (v){
                      FocusScope.of(context).unfocus();
                    },
                    readOnly: readOnly,
                    style: AppTextStyle.f500s16.copyWith(
                      color: AppColor.black09,
                      fontSize:  isTablet(context) ? 12.sp : 16.sp
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: AppTextStyle.f500s16.copyWith(
                        color: AppColor.grey77,
                        fontSize: isTablet(context) ? 12.sp : 16.sp
                      ),
                    ),
                  ),
                ),
                if (rightIcon != null) ...[
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: onRightIconTap,
                    child: AppSvgAsset(rightIcon!, height: 20.h, width: 20.h),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
