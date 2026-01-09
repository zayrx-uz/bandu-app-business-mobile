import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/forgot_password_otp_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final phoneController = TextEditingController();
  bool isActive = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_check);
  }

  void _check() {
    final phoneOk = phoneController.text.length == 12;
    errorText = null;
    if (isActive != phoneOk) {
      setState(() => isActive = phoneOk);
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordOtpScreen(
                  phoneNumber: phoneController.text.replaceAll(" ", ""),
                  otpToken: state.otpToken,
                ),
              ),
            );
          } else if (state is AuthErrorState) {
            errorText = state.message;
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoadingState;

          return Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                SizedBox(height: isTablet(context) ? 20.h : 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButtons(),
                    const TopAppName(),
                    SizedBox(width: 40.h),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => AppService.closeKeyboard(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.only(
                            left: isTablet(context) ? 30.w : 16.w,
                          ),
                          child: Text(
                            "forgotPassword".tr(),
                            style: AppTextStyle.f600s24.copyWith(
                              fontSize: isTablet(context) ? 18.sp : 24.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(
                            left: isTablet(context) ? 30.w : 16.w,
                          ),
                          child: Text(
                            "enterPhoneForReset".tr(),
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.grey58,
                              fontSize: isTablet(context) ? 12.sp : 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        InputPhoneWidget(controller: phoneController),
                        if (errorText != null)
                          Container(
                            margin: EdgeInsets.only(
                              left: isTablet(context) ? 30.w : 16.w,
                              top: 8.h,
                            ),
                            child: Text(
                              errorText!,
                              style: AppTextStyle.f400s16.copyWith(
                                color: AppColor.redED,
                                fontSize: isTablet(context) ? 12.sp : 16.sp,
                              ),
                            ),
                          ),
                        const Spacer(),
                        AppButton(
                          text: "continue".tr(),
                          onTap: () {
                            if (isActive && !isLoading) {
                              context.read<AuthBloc>().add(
                                    ForgotPasswordEvent(
                                      phoneNumber: "998${phoneController.text.replaceAll(" ", "")}",
                                    ),
                                  );
                            }
                          },
                          loading: isLoading,
                          isGradient: isActive,
                          backColor: isActive ? null : AppColor.greyE5,
                          txtColor: isActive ? null : AppColor.greyA7,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
