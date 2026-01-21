import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/device_helper/device_helper.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_employees_empty_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class EmptyEmployeeItemWidget extends StatelessWidget {
  final DashboardEmptyEmployee employee;

  const EmptyEmployeeItemWidget({super.key, required this.employee});

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
        child: Column(
          children: [
            Row(
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
                      Text(employee.fullName , style: TextStyle(
                        color : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp
                      ),),
                      Text("+${employee.phoneNumber}" , style: TextStyle(
                        color : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp
                      ),),
                    ],
                  ),
                )

              ],
            ),
            SizedBox(height: 10.h,),
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
