import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordResetScreen extends StatefulWidget {
  final String resetToken;

  const ForgotPasswordResetScreen({
    super.key,
    required this.resetToken,
  });

  @override
  State<ForgotPasswordResetScreen> createState() => _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? passwordError;
  String? confirmError;
  String? errorText;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_check);
    confirmPasswordController.addListener(_check);
  }

  void _check() {
    final password = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    errorText = null;

    if (password.isNotEmpty) {
      if (password.length < 8) {
        passwordError = "passwordMinLength".tr();
      } else if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
        passwordError = "passwordMustContainLetter".tr();
      } else {
        passwordError = null;
      }
    } else {
      passwordError = null;
    }

    if (confirm.isNotEmpty && password.isNotEmpty) {
      if (confirm != password) {
        confirmError = "passwordsMustMatch".tr();
      } else {
        confirmError = null;
      }
    } else {
      confirmError = null;
    }

    final passwordOk = password.length >= 8 && 
                       RegExp(r'[a-zA-Z]').hasMatch(password) && 
                       passwordError == null;
    final confirmOk = confirm == password && confirmError == null && confirm.isNotEmpty;

    setState(() {
      isActive = passwordOk && confirmOk;
    });
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessState) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is AuthErrorState) {
            setState(() {
              errorText = state.message;
              passwordError = null;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoadingState;

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
                            "newPassword".tr(),
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
                            "enterNewPassword".tr(),
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.grey58,
                              fontSize: isTablet(context) ? 12.sp : 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        InputPasswordWidget(
                          controller: newPasswordController,
                          title: "newPassword".tr(),
                          hint: "enterNewPassword".tr(),
                          trailingMessage: passwordError,
                        ),
                        SizedBox(height: 12.h),
                        InputPasswordWidget(
                          controller: confirmPasswordController,
                          title: "confirmPassword".tr(),
                          hint: "confirmPassword".tr(),
                          trailingMessage: confirmError,
                        ),
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
                          text: "save".tr(),
                          onTap: () {
                            if (isActive && !isLoading) {
                              context.read<AuthBloc>().add(
                                    ResetPasswordEvent(
                                      resetToken: widget.resetToken,
                                      newPassword: newPasswordController.text,
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
