import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/notification/notification_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationItem extends StatelessWidget {
  final NotificationItemData data;
  final VoidCallback? onTap;

  const NotificationItem({super.key, required this.data, this.onTap});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final dateStr = dateTime.toDDMMYYY();
    final timeStr = dateTime.toHHMM();
    return "$dateStr, $timeStr";
  }

  @override
  Widget build(BuildContext context) {
    final isRead = data.isRead;
    final backgroundColor = isRead ? Colors.white : AppColor.cFFF7DB;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            width: 1.w,
            color: AppColor.cE5E7E5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              data.description,
              style: TextStyle(
                color: AppColor.c666970,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.calendar,
                  width: 16.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatDateTime(data.sentAt),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
