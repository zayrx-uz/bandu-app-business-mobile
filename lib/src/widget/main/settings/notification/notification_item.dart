import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/notification/notification_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationItem extends StatefulWidget {
  final NotificationItemData data;
  final VoidCallback? onTap;

  const NotificationItem({super.key, required this.data, this.onTap});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _timezoneInitialized = false;

  @override
  void initState() {
    super.initState();
    _ensureTimezoneInitialized();
  }

  void _ensureTimezoneInitialized() {
    if (!_timezoneInitialized) {
      try {
        tz_data.initializeTimeZones();
        _timezoneInitialized = true;
      } catch (e) {
        _timezoneInitialized = true;
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    try {
      final tashkent = tz.getLocation('Asia/Tashkent');
      final tashkentTime = tz.TZDateTime.from(dateTime, tashkent);
      final dateStr = tashkentTime.toDDMMYYY();
      final timeStr = tashkentTime.toString().substring(11, 16);
      return "$dateStr, $timeStr";
    } catch (e) {
      final dateStr = dateTime.toDDMMYYY();
      final timeStr = dateTime.toHHMM();
      return "$dateStr, $timeStr";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = widget.data.isRead;
    final backgroundColor = isRead ? Colors.white : AppColor.cFFF7DB;

    return GestureDetector(
      onTap: widget.onTap,
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
              widget.data.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.data.description,
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
                  _formatDateTime(widget.data.sentAt),
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
