import 'dart:async';
import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/set_password_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String otpToken;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.otpToken,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController controller = TextEditingController();
  String? errorText;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  String _currentOtpToken = '';
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
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

  void _resendOtp() {
    if (_canResend) {
      _authBloc.add(
        RegisterEvent(phone: "998${widget.phoneNumber}"),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _timer?.cancel();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen:(prev , cur){
          return prev != cur;
        },
        listener: (context, state) {
          if (state is OtpSuccessState) {
            AppService.replacePage(
              context,
              BlocProvider(
                create: (_) => AuthBloc(authRepository: AuthRepository()),
                child: SetPasswordScreen(
                  token: state.token,
                ),
              ),
            );
          } else if (state is RegisterSuccessState) {
            _currentOtpToken = state.otpToken;
            _startTimer();
            controller.clear();
            if (mounted) {
              setState(() {});
            }
          } else if (state is AuthErrorState) {
            CenterDialog.errorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          bool loading = state is OtpLoadingState;
          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              leadingWidth: 56.w,
              leading: const BackButtons(),
              backgroundColor: AppColor.white,
              title: TopAppName(fontSize: 28.sp),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text("enterOtpCode".tr(), style: AppTextStyle.f600s24),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    "enterOtpDescription".tr(),
                    style: AppTextStyle.f400s16.copyWith(
                      color: AppColor.grey58,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    "+998 ${widget.phoneNumber}",
                    style: AppTextStyle.f400s16,
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  alignment: Alignment.center,
                  child: Pinput(
                    length: 6,
                    controller: controller,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) {
                      if (v.length == 6) {
                        BlocProvider.of<AuthBloc>(context).add(
                            OtpEvent(otpToken: _currentOtpToken, code: v)
                        );
                      }
                    },
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
                    margin: EdgeInsets.only(left: 16.w, top: 12.h, right: 16.w),
                    child: Text(
                      errorText!,
                      style: AppTextStyle.f400s16.copyWith(
                        color: AppColor.redED,
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),
                Center(
                  child: _canResend
                      ? GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            "resend".tr(),
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.yellowFF,
                            ),
                          ),
                        )
                      : Text(
                          "${_secondsRemaining}s",
                          style: AppTextStyle.f400s16.copyWith(
                            color: AppColor.grey77,
                          ),
                        ),
                ),
                Spacer(),
                AppButton(
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      OtpEvent(
                        otpToken: _currentOtpToken,
                        code: controller.text,
                      ),
                    );
                  },
                  loading: loading,
                  text: "continue".tr(),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
