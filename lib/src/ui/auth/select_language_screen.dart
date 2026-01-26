import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/onboard/on_borading.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/auth/select_langugae_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/service/rx_bus.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  int select = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cF4F5F4,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10.h),
            Column(
              children: [
                Image.asset(AppImages.language, width: 274.w, height: 144.h),
                SizedBox(height: 8.h),
                Text(
                  "selectLanguage".tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                SelectLanguageItem(
                  text: "uzbek".tr(),
                  image: AppImages.uzbImage,
                  isSelect: select == 0,
                  onTap: () {
                    CacheService.saveString('language', "uz");
                    if (EasyLocalization.of(context) != null) {
                      context.setLocale(const Locale("uz", "UZ"));
                      RxBus.post(tag: "language_changed", 1);
                    }
                    select = 0;
                    setState(() {});
                  },
                ),
                SizedBox(height: 12.h),
                SelectLanguageItem(
                  text: "russian".tr(),
                  image: AppImages.ruImage,
                  isSelect: select == 1,
                  onTap: () {
                    CacheService.saveString('language', "ru");
                    if (EasyLocalization.of(context) != null) {
                      context.setLocale(const Locale("ru", "RU"));
                      RxBus.post(tag: "language_changed", 1);
                    }

                    select = 1;
                    setState(() {});
                  },
                ),
                SizedBox(height: 12.h),
                SelectLanguageItem(
                  text: "english".tr(),
                  image: AppImages.enImage,
                  isSelect: select == 2,
                  onTap: () {
                    CacheService.saveString('language', "en");
                    if (EasyLocalization.of(context) != null) {
                      context.setLocale(const Locale("en", "EN"));
                      RxBus.post(tag: "language_changed", 1);
                    }
                    select = 2;
                    setState(() {});
                  },
                ),
              ],
            ),
            AppButton(
              onTap: () {
                CacheService.saveBool("select_lan", true);

                AppService.changePage(context, Onboarding());
              },
              text: "continue".tr(),
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
