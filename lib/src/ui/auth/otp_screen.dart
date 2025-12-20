import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/company/screen/select_company_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSuccessState) {
            Navigator.popUntil(context, (route) => route.isFirst);
            AppService.replacePage(
              context,
              BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: SelectCompanyScreen(),
              ),
            );
          } else if (state is AuthErrorState) {
            errorText = state.message;
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
                  child: Text("Enter OTP Code", style: AppTextStyle.f600s24),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    "Enter the 6-digit OTP code that we sent to",
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
                Spacer(),
                AppButton(
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      OtpEvent(
                        otpToken: widget.otpToken,
                        code: controller.text,
                      ),
                    );
                  },
                  loading: loading,
                  text: "Continue",
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
