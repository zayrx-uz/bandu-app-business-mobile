import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CenterDialog {
  static void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("logOut".tr() , style  : TextStyle(
              fontSize : isTablet(context) ? 12.sp : 16.sp
          ),),
          content: Text("areYouSureLogOut".tr() , style  : TextStyle(
              fontSize : isTablet(context) ? 8.sp : 12.sp
          ),),
          actions: [
            CupertinoButton(
              child: Text(
                "cancel".tr(),
                style: AppTextStyle.f600s16.copyWith(color: AppColor.blue00 , fontSize : isTablet(context) ? 12.sp : 16.sp),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "logOut".tr(),
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
            "deleteAccount".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          content: Text(
            "areYouSureDeleteAccountPermanent".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 8.sp : 12.sp,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "cancel".tr(),
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
                "delete".tr(),
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


  static void deleteResourceDialog(BuildContext context , {required String name , required int id , required VoidCallback onTapDelete}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "deleteResource".tr(),
            style: TextStyle(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          content: Text(
            "${"deleteResourceConfirm".tr()} ($name)?",
            style: TextStyle(
              fontSize: isTablet(context) ? 8.sp : 12.sp,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                "cancel".tr(),
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
                "delete".tr(),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.red00,
                  fontSize: isTablet(context) ? 12.sp : 16.sp,
                ),
              ),
              onPressed: onTapDelete,
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
          title: Text("soon".tr() , style: TextStyle(
            fontSize : isTablet(context) ? 12.sp : 16.sp
          ),),
          content: Text(text , style: TextStyle(
             fontSize:  isTablet(context) ? 8.sp : 12.sp
          ),),
          actions: [
            CupertinoButton(
              child: Text(
                "ok".tr(),
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
          title: Text("rateOurApp".tr()),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("pleaseRateExperience".tr()),
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
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("submit".tr()),
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
            "error".tr(),
            style: AppTextStyle.f600s16.copyWith(color: AppColor.red00 , fontSize: isTablet(context) ? 8.sp : 16.sp),
          ),
          content: Text(text, style: AppTextStyle.f400s16),
          actions: [
            CupertinoButton(
              child: Text(
                "ok".tr(),
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
            "success".tr(),
            style: AppTextStyle.f600s16.copyWith(color: AppColor.green34),
          ),
          content: Text(text, style: AppTextStyle.f400s16),
          actions: [
            CupertinoButton(
              child: Text(
                "ok".tr(),
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
