import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.text, this.icon});

  final String text;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon ?? AppIcons.starMsg, width: 200.w, fit: BoxFit.cover),
          SizedBox(height: 10.h),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
