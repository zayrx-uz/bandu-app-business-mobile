import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final uzPhoneMask = MaskTextInputFormatter(
  mask: '## ### ## ##',
  filter: {'#': RegExp(r'\d')},
);

class InputPhoneWidget extends StatelessWidget {
  final TextEditingController controller;

  const InputPhoneWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phone Number",
            style: AppTextStyle.f500s16.copyWith(color: AppColor.black09),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 48.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColor.greyFA,
              border: Border.all(width: 1.h, color: AppColor.greyE5),
            ),
            child: Row(
              children: [
                SizedBox(width: 16.h),
                Image.asset(AppImages.uz, height: 16.h, width: 16.h),
                SizedBox(width: 4.w),
                Text(
                  "+998",
                  style: AppTextStyle.f600s16.copyWith(color: AppColor.black09),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.keyboard_arrow_down_outlined, size: 16.h),
                SizedBox(width: 16.w),
                Container(height: 48.h, width: 1.w, color: AppColor.greyE5),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: AppTextStyle.f500s16.copyWith(
                      color: AppColor.black09,
                    ),
                    inputFormatters: <TextInputFormatter>[uzPhoneMask],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "-- --- -- --",
                      hintStyle: AppTextStyle.f500s16.copyWith(
                        color: AppColor.grey77,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
