import 'dart:async';
import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/forgot_password_reset_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../theme/app_color.dart' show AppColor;

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String otpToken;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.otpToken,
  });

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final otpController = TextEditingController();
  bool isActive = false;
  String? errorText;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  String _currentOtpToken = '';
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    otpController.addListener(_check);
    _currentOtpToken = widget.otpToken;
    _authBloc = AuthBloc(authRepository: AuthRepository());
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _check() {
    final otpOk = otpController.text.length == 6;
    errorText = null;
    if (isActive != otpOk) {
      setState(() => isActive = otpOk);
    }
  }

  void _resendOtp() {
    if (_canResend) {
      _authBloc.add(
        ForgotPasswordEvent(phoneNumber: "998${widget.phoneNumber}"),
      );
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyResetCodeSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordResetScreen(
                  resetToken: state.resetToken,
                ),
              ),
            );
          } else if (state is ForgotPasswordSuccessState) {
            _currentOtpToken = state.otpToken;
            _startTimer();
            errorText = null;
            otpController.clear();
            if (mounted) {
              setState(() {});
            }
          } else if (state is AuthErrorState) {
            errorText = state.message;
            if (mounted) {
              setState(() {});
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyResetCodeLoadingState;
          final isResending = state is ForgotPasswordLoadingState;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.only(
                          left: isTablet(context) ? 30.w : 16.w,
                        ),
                        child: Text(
                          "enterOtpCode".tr(),
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
                          "enterOtpDescription".tr(),
                          style: AppTextStyle.f400s16.copyWith(
                            color: AppColor.grey58,
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: isTablet(context) ? 30.w : 16.w,
                        ),
                        child: Text(
                          "+998 ${widget.phoneNumber}",
                          style: AppTextStyle.f400s16.copyWith(
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        alignment: Alignment.center,
                        child: Pinput(
                          length: 6,
                          controller: otpController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          defaultPinTheme: PinTheme(
                            width: 48.w,
                            height: 48.h,
                            textStyle: AppTextStyle.f600s20,
                            decoration: BoxDecoration(
                              color: AppColor.greyFA,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColor.greyE5),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 48.w,
                            height: 48.h,
                            textStyle: AppTextStyle.f600s20,
                            decoration: BoxDecoration(
                              color: AppColor.greyFA,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColor.yellowFF,
                                width: 1.h,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 1,
                                  spreadRadius: 2,
                                  color: AppColor.yellowFFC.withValues(alpha: .36),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (errorText != null)
                        Container(
                          margin: EdgeInsets.only(
                            left: isTablet(context) ? 30.w : 16.w,
                            right: isTablet(context) ? 30.w : 16.w,
                            top: 12.h,
                          ),
                          child: Text(
                            errorText!,
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.redED,
                              fontSize: isTablet(context) ? 12.sp : 16.sp,
                            ),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      Center(
                        child: _canResend
                            ? GestureDetector(
                          onTap: isResending ? null : _resendOtp,
                          child: Text(
                            isResending ? "loading".tr() : "resend".tr(),
                            style: AppTextStyle.f400s16.copyWith(
                              color: isResending ? AppColor.grey77 : AppColor.yellowFF,
                              fontSize: isTablet(context) ? 12.sp : 16.sp,
                            ),
                          ),
                        )
                            : Text(
                          "${"resendTime".tr()} ($_secondsRemaining s)",
                          style: AppTextStyle.f400s16.copyWith(
                            color: AppColor.grey77,
                            fontSize: isTablet(context) ? 12.sp : 16.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                        text: "continue".tr(),
                        onTap: () {
                          if (isActive && !isLoading) {
                            _authBloc.add(
                              VerifyResetCodeEvent(
                                phoneNumber: "998${widget.phoneNumber}",
                                code: otpController.text,
                                otpToken: _currentOtpToken,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
