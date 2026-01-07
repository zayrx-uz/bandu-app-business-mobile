import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CenterDialog {
  static void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Log Out" , style  : TextStyle(
              fontSize : isTablet(context) ? 12.sp : 16.sp
          ),),
          content: Text("Are you sure you want to log out?" , style  : TextStyle(
              fontSize : isTablet(context) ? 8.sp : 12.sp
          ),),
          actions: [
            CupertinoButton(
              child: Text(
                "Cancel",
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00 , fontSize : isTablet(context) ? 12.sp : 16.sp),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "Log Out",
                style: AppTextStyle.f600s16.copyWith(color: AppColor.red00 , fontSize : isTablet(context) ? 12.sp : 16.sp),
              ),
              onPressed: () {
                CacheService.clear();
                Navigator.of(context).popUntil((route) => route.isFirst);
                AppService.replacePage(context, OnboardScreen());
              },
            ),
          ],
        );
      },
    );
  }

  static void deleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Delete Account",
            style: TextStyle(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          content: Text(
            "Are you sure you want to delete your account? This action is permanent and all your data will be lost.",
            style: TextStyle(
              fontSize: isTablet(context) ? 8.sp : 12.sp,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "Cancel",
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.blue00,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "Delete",
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.red00,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: () {
                CacheService.clear();
                Navigator.of(context).popUntil((route) => route.isFirst);
                AppService.replacePage(context, OnboardScreen());
              },
            ),
          ],
        );
      },
    );
  }

  static void soonDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Soon" , style: TextStyle(
            fontSize : isTablet(context) ? 12.sp : 16.sp
          ),),
          content: Text(text , style: TextStyle(
             fontSize:  isTablet(context) ? 8.sp : 12.sp
          ),),
          actions: [
            CupertinoButton(
              child: Text(
                "Ok",
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00 , fontSize : isTablet(context) ? 12.sp : 16.sp),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void showCustomRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        double rating = 0;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text("Rate our app"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please rate your experience"),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => rating = i + 1.0),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  static void errorDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Error",
            style: AppTextStyle.f600s16.copyWith(color: AppColor.red00 , fontSize: isTablet(context) ? 8.sp : 16.sp),
          ),
          content: Text(text, style: AppTextStyle.f400s16),
          actions: [
            CupertinoButton(
              child: Text(
                "Ok",
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00 , fontSize:  isTablet(context) ? 12.sp : 16.sp),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void successDialog(
    BuildContext context,
    String text,
    Function() onTap,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Success",
            style: AppTextStyle.f600s16.copyWith(color: AppColor.green34),
          ),
          content: Text(text, style: AppTextStyle.f400s16),
          actions: [
            CupertinoButton(
              child: Text(
                "Ok",
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    ).then((d) {
      onTap();
    });
  }
}
