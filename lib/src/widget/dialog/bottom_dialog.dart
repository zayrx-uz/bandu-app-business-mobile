import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/auth/select_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomDialog {
  static void langDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4.h,
                width: 56.w,
                margin: EdgeInsets.only(top: 12.h, bottom: 24.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: AppColor.greyF4,
                ),
              ),
              Text("Select language", style: AppTextStyle.f600s24),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColor.white,
                  border: Border.all(width: 1.h, color: AppColor.greyE5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("English", style: AppTextStyle.f500s16),
                    ),
                    Container(
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4.h,
                          color: AppColor.yellowFFC,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              AppButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: "Save",
                margin: EdgeInsets.zero,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  static void selectLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SelectLoginWidget();
      },
    );
  }


}
