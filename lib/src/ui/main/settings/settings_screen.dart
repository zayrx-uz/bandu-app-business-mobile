import 'dart:io';

import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/constants.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/company/screen/select_company_screen.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/settings/profile_widget.dart';
import 'package:bandu_business/src/widget/main/settings/settings_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  InAppReview review = InAppReview.instance;

  @override
  void initState() {
    setBus();
    super.initState();
  }

  void setBus() {
    RxBus.register(tag: "settings").listen((s) async {
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.greyF4,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileWidget(),
            Transform.translate(
              offset: Offset(0, -50.h),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(width: 1.h, color: AppColor.greyE5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("General", style: AppTextStyle.f600s20),
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.money,
                      text: "My Cards",
                      onTap: () {
                        CenterDialog.soonDialog(
                          context,
                          "My cards will be added soon.",
                        );
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.menu,
                      text: "Select company",
                      onTap: () {
                        AppService.changePage(
                          context,
                          BlocProvider(
                            create: (_) =>
                                HomeBloc(homeRepository: HomeRepository()),
                            child: SelectCompanyScreen(canPop: true),
                          ),
                        );
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.globe,
                      text: "Change Language",
                      onTap: () {
                        BottomDialog.langDialog(context);
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.help,
                      text: "Help",
                      margin: EdgeInsets.zero,
                      onTap: () {
                        launchUrl(Uri.parse(help));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -42.h),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(width: 1.h, color: AppColor.greyE5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Support", style: AppTextStyle.f600s20),
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.terms,
                      text: "Terms & Conditions",
                      onTap: () {
                        launchUrl(Uri.parse(terms));
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.fingerprint,
                      text: "Policy & Privacy",
                      onTap: () {
                        launchUrl(Uri.parse(privacy));
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.star,
                      text: "Give Rating",
                      margin: EdgeInsets.zero,
                      onTap: () async {
                        if (Platform.isAndroid) {
                          CenterDialog.showCustomRateDialog(context);
                        } else {
                          await review.requestReview();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -34.h),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(width: 1.h, color: AppColor.greyE5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Logout", style: AppTextStyle.f600s20),
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.logout,
                      text: "Log Out",
                      isLogout: true,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        CenterDialog.logoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
