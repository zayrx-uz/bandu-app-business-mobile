import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableEmployeeItemWidget extends StatelessWidget {
  final EmployeeItemData employee;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableEmployeeItemWidget({
    super.key,
    required this.employee,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: isSelected ? AppColor.yellowFFC.withValues(alpha: 0.1) : AppColor.white,
          border: Border.all(
            width: isSelected ? 1.5.h : 1.h,
            color: isSelected ? AppColor.yellowFFC : AppColor.greyE5,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: employee.profilePicture?.toString(),
                  height: 40.h,
                  width: 40.h,
                  borderRadius: 100,
                ),
                if (isSelected)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.yellowFFC,
                        border: Border.all(
                          width: 1.5.h,
                          color: AppColor.white,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 10.sp,
                        color: AppColor.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    employee.fullName,
                    style: AppTextStyle.f500s16.copyWith(
                      color: AppColor.black09,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    employee.roles.isNotEmpty
                        ? employee.roles.first.toUpperCase()
                        : "",
                    style: AppTextStyle.f400s14.copyWith(
                      color: AppColor.grey58,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
