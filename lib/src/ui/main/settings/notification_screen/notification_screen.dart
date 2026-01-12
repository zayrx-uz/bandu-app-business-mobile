import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/settings/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cF4F5F4,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            onTap: () {},
            text: "Mark as Read",
            border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
            isGradient: false,
            backColor: Colors.white,
            txtColor: Colors.black,
            leftIconColor: Colors.black,
            leftIcon: AppIcons.ticksIcon,
          ),
          SizedBox(height: 36.h),
        ],
      ),
      body: Column(
        children: [
          TopBarWidget(text: "Notifications", isBack: true),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "8 November 2025",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                NotificationItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
