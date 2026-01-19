import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/device_helper/device_helper.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_employees_booked_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class BookedEmployeeItemWidget extends StatelessWidget {
  final DashboardBookedEmployee employee;

  const BookedEmployeeItemWidget({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColor.white,
        border: Border.all(width: 1.h, color: AppColor.greyE5),
      ),
      child: Padding(
        padding: EdgeInsets.all(DeviceHelper.isTablet(context) ? 6.w : 12.w),
        child: Row(
          children: [
            CustomNetworkImage(
              imageUrl: employee.profilePicture,
              height: 48.h,
              width: 48.h,
              borderRadius: 100,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.fullName,
                    maxLines: 1,
                    style: AppTextStyle.f500s16.copyWith(
                      fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    employee.phoneNumber.phoneFormat(),
                    style: AppTextStyle.f400s14.copyWith(
                      color: AppColor.grey58,
                      fontSize: DeviceHelper.isTablet(context) ? 10.sp : 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              onTap: () {
                launchUrl(
                  Uri.parse('tel:${employee.phoneNumber.phoneFormat()}'),
                );
              },
              height: 40.h,
              isGradient: false,
              backColor: AppColor.white,
              margin: EdgeInsets.zero,
              text: "callPerson".tr(),
              txtColor: AppColor.black,
              leftIcon: AppIcons.call,
              border: Border.all(
                width: 1.h,
                color: AppColor.greyE5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
