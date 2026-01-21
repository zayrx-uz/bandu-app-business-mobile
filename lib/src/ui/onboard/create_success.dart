import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/main/company/screen/select_company_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateSuccess extends StatefulWidget {
  const CreateSuccess({super.key});

  @override
  State<CreateSuccess> createState() => _CreateSuccessState();
}

class _CreateSuccessState extends State<CreateSuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            SizedBox(height: 50.h),
            const TopAppName(),
            SizedBox(height: 50.h),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                AppImages.createSuccess,
                width: isTablet(context) ? 200.w : double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: isTablet(context) ? 30.h : 75.h),
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  Text(
                    "accountVerified".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isTablet(context) ? 20.sp : 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "accountVerifiedDescription".tr(),
                      style: TextStyle(
                        color: AppColor.c717784,
                        fontSize: isTablet(context) ? 12.sp : 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: EdgeInsets.only(bottom: 36.h),
                child: AppButton(
                  onTap: () {
                    AppService.changePage(
                      context,
                      BlocProvider(
                        create: (_) => HomeBloc(homeRepository: HomeRepository()),
                        child: SelectCompanyScreen(),
                      ),
                    );
                  },
                  text: "getStarted".tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
