import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/main/main_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/auth/on_boarding/slider_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SliderWidget(
        imageWidth: isTablet(context) ? 150.w : 286.w,
        imageHeight: isTablet(context) ? 150.w : 286.w,
        title: "onboardingWelcomeTitle".tr(),
        subTitle: "onboardingDescription".tr(),
        sizedBoxHeight: isTablet(context) ? 100 : 150,
        image: AppImages.image1,
      ),
      SliderWidget(
        imageWidth: isTablet(context) ? 150.w : 286.w,
        imageHeight: isTablet(context) ? 150.w : 286.w,
        title: "onboardingRestaurantTitle".tr(),
        subTitle: "onboardingDescription".tr(),
        sizedBoxHeight: isTablet(context) ? 100 : 150,

        image: AppImages.image2,
      ),
      SliderWidget(
        imageWidth: isTablet(context) ? 150.w : 286.w,
        imageHeight: isTablet(context) ? 150.w : 286.w,
        sizedBoxHeight: isTablet(context) ? 100 : 150,
        title: "onboardingHairSalonTitle".tr(),
        subTitle: "onboardingDescription".tr(),
        image: AppImages.image3,
      ),
      SliderWidget(
        imageWidth: isTablet(context) ? 150.w : 286.w,
        imageHeight: isTablet(context) ? 150.w : 286.w,
        sizedBoxHeight: isTablet(context) ? 100 : 150,
        title: "onboardingCarWashTitle".tr(),
        subTitle: "onboardingDescription".tr(),
        image: AppImages.image4,
      ),
      SliderWidget(
        imageWidth: isTablet(context) ? 150.w : 286.w,
        imageHeight: isTablet(context) ? 150.w : 286.w,
        sizedBoxHeight: isTablet(context) ? 100 : 150,
        title: "onboardingClinicTitle".tr(),
        subTitle: "onboardingDescription".tr(),
        image: AppImages.image5,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemCount: pages.length,
              physics: const AlwaysScrollableScrollPhysics(),
              onPageChanged: _onChanged,
              itemBuilder: (context, int index) {
                return Container(child: pages[index]);
              },
            ),
            _currentPage != (pages.length - 1)
                ? Positioned(
                    bottom: 70.h,
                    left: 16.w,
                    right: 16.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _currentPage != 0
                                ? InkWell(
                                    onTap: () {
                                      if (_currentPage == (pages.length - 1)) {
                                        CacheService.saveBool(
                                          "onboarding_view",
                                          true,
                                        );
                                        AppService.replacePage(
                                          context,
                                          const OnboardScreen(),
                                        );
                                      } else {
                                        _controller.animateToPage(
                                          _currentPage - 1,
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          curve: Curves.easeInOutQuint,
                                        );
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      height: 48.h,
                                      width: 52.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          width: 1.w,
                                          color: AppColor.yellowFFC,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 0),
                                            spreadRadius: 4,
                                            blurRadius: 4,
                                            color: AppColor.yellowFFC
                                                .withOpacity(0.2),
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            AppColor.yellowFFC,
                                            AppColor.yellowFFC,
                                          ],
                                        ),
                                      ),
                                      child: AppSvgAsset(
                                        AppIcons.arrowLeft,
                                        width: isTablet(context) ? 16.w : 20.w,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(pages.length, (
                            int index,
                          ) {
                            return AnimatedContainer(
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 300),
                              height: 8.h,
                              width: 8.h,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentPage
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),

                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                if (_currentPage == (pages.length - 1)) {
                                  CacheService.saveBool(
                                    "onboarding_view",
                                    true,
                                  );
                                  AppService.replacePage(
                                    context,
                                    const MainScreen(),
                                  );
                                } else {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOutQuint,
                                  );
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 48.h,
                                width: 52.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: AppColor.yellowFFC,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      spreadRadius: 4,
                                      blurRadius: 4,
                                      color: AppColor.yellowFFC.withOpacity(
                                        0.2,
                                      ),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColor.yellowFFC,
                                      AppColor.yellowFFC,
                                    ],
                                  ),
                                ),
                                child: AppSvgAsset(
                                  AppIcons.arrowRight,
                                  width: isTablet(context) ? 16.w : 20.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Positioned(
                    bottom: 70.h,
                    left: 16.w,
                    right: 16.w,
                    child: AppButton(
                      onTap: () {
                        if (_currentPage == (pages.length - 1)) {
                          CacheService.saveBool("onboarding_view", true);
                          AppService.replacePage(
                            context,
                            const OnboardScreen(),
                          );
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOutQuint,
                          );
                        }
                      },
                      text: "continue".tr(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
