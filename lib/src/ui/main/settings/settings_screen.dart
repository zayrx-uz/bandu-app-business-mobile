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
import 'package:bandu_business/src/ui/main/settings/resource/resource_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/dialog/bottom_dialog.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/settings/profile_widget.dart';
import 'package:bandu_business/src/widget/main/settings/settings_button_widget.dart';
import 'package:bandu_business/src/provider/api_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(GetMeEvent());
      }
    });
  }

  void setBus() {
    RxBus.register(tag: "settings").listen((s) async {
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        context.read<HomeBloc>().add(GetMeEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.greyF4,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(GetMeEvent());
              await Future.delayed(Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
          children: [
            ProfileWidget(),
            Transform.translate(
              offset: Offset(0, isTablet(context) ? -20 : -50.h),
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
                    Text("general".tr(), style: AppTextStyle.f600s20.copyWith(
                      fontSize:  isTablet(context) ? 12.sp : 20.sp
                    )),
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.menu,
                      text: "selectCompany".tr(),
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
                      text: "changeLanguage".tr(),
                      onTap: () {
                        BottomDialog.langDialog(context);
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.help,
                      text: "help".tr(),
                      margin: EdgeInsets.zero,
                      onTap: () {
                        launchUrl(Uri.parse(help));
                      },
                    ),
                    if (kDebugMode && ApiProvider.alice != null) ...[
                      SizedBox(height: 16.h),
                      SettingsButtonWidget(
                        icon: AppIcons.monitoring,
                        text: "HTTP Inspector",
                        margin: EdgeInsets.zero,
                        onTap: () {
                          ApiProvider.alice?.showInspector();
                        },
                      ),
                    ],
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.money,
                      text: "resource".tr(),
                      onTap: () {
                        AppService.changePage(
                          context,
                          BlocProvider(
                            create: (_) =>
                                HomeBloc(homeRepository: HomeRepository()),
                            child: ResourceScreen(),
                          ),
                        );
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
                    Text("support".tr(), style: AppTextStyle.f600s20.copyWith(
                       fontSize:  isTablet(context) ? 12.sp : 20.sp
                    )),
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.terms,
                      text: "termsConditions".tr(),
                      onTap: () {
                        launchUrl(Uri.parse(terms));
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.fingerprint,
                      text: "policyPrivacy".tr(),
                      onTap: () {
                        launchUrl(Uri.parse(privacy));
                      },
                    ),
                    SettingsButtonWidget(
                      icon: AppIcons.star,
                      text: "giveRating".tr(),
                      margin: EdgeInsets.zero,
                      onTap: () async {
                        if (Platform.isAndroid) {
                          await launchUrl(
                            Uri.parse(
                              'https://play.google.com/store/apps/details?id=uz.mobile.bandu&hl=ru',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          await launchUrl(
                            Uri.parse(
                              'https://apps.apple.com/us/app/bandu/id6757488779',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
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
                    Text("logout".tr(), style: AppTextStyle.f600s20.copyWith(
                       fontSize:  isTablet(context) ? 12.sp :20.sp
                    )),
                    SizedBox(height: 16.h),
                    SettingsButtonWidget(
                      icon: AppIcons.logout,
                      text: "logOut".tr(),
                      isLogout: true,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        CenterDialog.logoutDialog(context);
                      },
                    ),
                    SizedBox(height: 10.h),
                    SettingsButtonWidget(
                      icon: AppIcons.delete,
                      text: "deleteAccount".tr(),
                      isLogout: true,
                      margin: EdgeInsets.zero,
                      onTap: () {
                        CenterDialog.deleteAccountDialog(context);
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
        },
      ),
    );
  }
}
