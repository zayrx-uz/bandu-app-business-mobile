import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/auth/select_login_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/constants/app_images.dart';

class BottomDialog {
  static void langDialog(BuildContext context) {
    final parentContext = context;
    showModalBottomSheet(
      context: context,
      builder: (dialogContext) {
        final currentLocale = EasyLocalization.of(parentContext)?.locale ?? const Locale('ru', 'RU');
        String currentLang = 'ru';
        if (currentLocale.languageCode == 'en') {
          currentLang = 'en';
        } else if (currentLocale.languageCode == 'uz') {
          currentLang = 'uz';
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final locale = EasyLocalization.of(parentContext)?.locale ?? const Locale('ru', 'RU');
            return EasyLocalization(
              supportedLocales: const [Locale('en', 'EN'), Locale('ru', 'RU'), Locale('uz', 'UZ')],
              path: 'assets/translations',
              startLocale: locale,
              fallbackLocale: const Locale('ru', 'RU'),
              child: Builder(
                builder: (localizedContext) {
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

                        Text("selectLanguage".tr(), style: AppTextStyle.f600s24),
                        SizedBox(height: 16.h),

                        GestureDetector(
                          onTap: () {
                            CacheService.saveString('language', "en");
                            if (EasyLocalization.of(parentContext) != null) {
                              parentContext.setLocale(const Locale("en", "EN"));
                              RxBus.post(tag: "language_changed", 1);
                            }
                            setState(() {
                              currentLang = "en";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColor.white,
                              border: Border.all(
                                width: 1.h,
                                color: currentLang == "en" ? AppColor.yellowFFC : AppColor.greyE5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "english".tr(),
                                    style: AppTextStyle.f500s16.copyWith(
                                      fontWeight: currentLang == "en" ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: currentLang == "en" ? 6.h : 2.h,
                                      color: currentLang == "en" ? AppColor.yellowFFC : AppColor.greyE5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        GestureDetector(
                          onTap: () {
                            CacheService.saveString('language', "ru");
                            if (EasyLocalization.of(parentContext) != null) {
                              parentContext.setLocale(const Locale("ru", "RU"));
                              RxBus.post(tag: "language_changed", 1);
                            }
                            setState(() {
                              currentLang = "ru";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColor.white,
                              border: Border.all(
                                width: 1.h,
                                color: currentLang == "ru" ? AppColor.yellowFFC : AppColor.greyE5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "russian".tr(),
                                    style: AppTextStyle.f500s16.copyWith(
                                      fontWeight: currentLang == "ru" ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: currentLang == "ru" ? 6.h : 2.h,
                                      color: currentLang == "ru" ? AppColor.yellowFFC : AppColor.greyE5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        GestureDetector(
                          onTap: () {
                            CacheService.saveString('language', "uz");
                            if (EasyLocalization.of(parentContext) != null) {
                              parentContext.setLocale(const Locale("uz", "UZ"));
                              RxBus.post(tag: "language_changed", 1);
                            }
                            setState(() {
                              currentLang = "uz";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColor.white,
                              border: Border.all(
                                width: 1.h,
                                color: currentLang == "uz" ? AppColor.yellowFFC : AppColor.greyE5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "uzbek".tr(),
                                    style: AppTextStyle.f500s16.copyWith(
                                      fontWeight: currentLang == "uz" ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: currentLang == "uz" ? 6.h : 2.h,
                                      color: currentLang == "uz" ? AppColor.yellowFFC : AppColor.greyE5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        AppButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "save".tr(),
                          margin: EdgeInsets.zero,
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  );
                },
              ),
            );
          },
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



  static void serverError(BuildContext context,) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) {
        return EasyLocalization(
          supportedLocales: const [Locale('en', 'EN'), Locale('ru', 'RU'), Locale('uz', 'UZ')],
          path: 'assets/translations',
          startLocale: EasyLocalization.of(context)?.locale ?? const Locale('ru', 'RU'),
          fallbackLocale: const Locale('ru', 'RU'),
          child: Builder(
            builder: (localizedContext) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color : Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                          topLeft: Radius.circular(16.r)
                      )
                  ),
                  child : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 12.h,),
                      Container(
                        width: 56.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                            color : AppColor.cE5E7E5,
                            borderRadius: BorderRadius.circular(100.r)
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Image.asset(AppImages.server , width: 200.w,fit : BoxFit.cover),
                      SizedBox(height: 10.h,),
                      Text("errorServer".tr() , style: TextStyle(
                          color : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp
                      ),),
                      SizedBox(height: 8.h,),
                      Text("somethingWentWrong".tr() , style: TextStyle(
                          color : AppColor.c6C6C6C,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp
                      ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h,),
                      AppButton(
                        onTap: (){
                          Navigator.pop(context);
                        } ,
                        isGradient: false,
                        txtColor: Colors.black,
                        text: "goBack".tr(),backColor: Colors.white,border: Border.all(
                          width: 1.w,
                          color : AppColor.cE5E7E5
                      ),),
                      SizedBox(height: 40.h,),
                    ],
                  )
              );
            },
          ),
        );
      },
    );
  }


  static void noConnection(BuildContext context,) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: EasyLocalization(
            supportedLocales: const [Locale('en', 'EN'), Locale('ru', 'RU'), Locale('uz', 'UZ')],
            path: 'assets/translations',
            startLocale: EasyLocalization.of(context)?.locale ?? const Locale('ru', 'RU'),
            fallbackLocale: const Locale('ru', 'RU'),
            child: Builder(
              builder: (localizedContext) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color : Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.r),
                            topLeft: Radius.circular(16.r)
                        )
                    ),
                    child : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 12.h,),
                        Container(
                          width: 56.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                              color : AppColor.cE5E7E5,
                              borderRadius: BorderRadius.circular(100.r)
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Image.asset(AppImages.noConnection , width: 200.w,fit : BoxFit.cover),
                        SizedBox(height: 10.h,),
                        Text("noConnection".tr() , style: TextStyle(
                            color : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 24.sp
                        ),),
                        SizedBox(height: 8.h,),
                        Text("somethingWentWrong".tr() , style: TextStyle(
                            color : AppColor.c6C6C6C,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp
                        ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.h,),
                      ],
                    )
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void bookCancel(BuildContext context, {required int bookingId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) {
        return EasyLocalization(
          supportedLocales: const [Locale('en', 'EN'), Locale('ru', 'RU'), Locale('uz', 'UZ')],
          path: 'assets/translations',
          startLocale: EasyLocalization.of(context)?.locale ?? const Locale('ru', 'RU'),
          fallbackLocale: const Locale('ru', 'RU'),
          child: Builder(
            builder: (localizedContext) {
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
                    SizedBox(height: 12.h),
                    Container(
                      height: 4.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: AppColor.greyF4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "cancelBooking".tr(),
                      style: AppTextStyle.f600s24,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "areYouSureCancelBooking".tr(),
                      style: AppTextStyle.f400s16.copyWith(
                        color: AppColor.grey58,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    AppButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: "cancel".tr(),
                      margin: EdgeInsets.zero,
                      isGradient: false,
                      backColor: AppColor.white,
                      border: Border.all(width: 1.h, color: AppColor.greyE5),
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: "confirm".tr(),
                      margin: EdgeInsets.zero,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

}
