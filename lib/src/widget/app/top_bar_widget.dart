import 'dart:io';

import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBarWidget extends StatelessWidget {
  final String text;
  final Widget? left;
  final Widget? right;
  final bool isBack;
  final bool isAppName;

  const TopBarWidget({
    super.key,
    this.text = '',
    this.left,
    this.right,
    this.isBack = false,
    this.isAppName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top:
            MediaQuery.of(context).padding.top +
            (Platform.isAndroid ? 12.h : 0),
        bottom: Platform.isAndroid ? 12.h : 6.h,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(
          bottom: BorderSide(width: 1.h, color: AppColor.greyD6),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          if (isBack) BackButtons(),
          if (left != null) left!,
          Spacer(),
          if (isAppName)
            TopAppName()
          else
            Text(text, style: AppTextStyle.f600s20),
          Spacer(),
          if (right != null) right!,
          if (isBack) SizedBox(width: 56.h),
        ],
      ),
    );
  }
}
