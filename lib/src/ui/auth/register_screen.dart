import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/otp_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/app/back_button.dart' show BackButtons;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        listenWhen: (prev , cur){
          return prev != cur;
        },
        listener: (context, state) {
          if(state is RegisterSuccessState){
            AppService.replacePage(
              context,
              BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: OtpScreen(otpToken: state.otpToken,phoneNumber: phoneController.text,),
              ),
            );
          }
          if(state is AuthErrorState){
            CenterDialog.errorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoadingState;
          return Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                SizedBox(height: isTablet(context) ? 20.h : 50.h),
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
                            "register".tr(),
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
                            "startCreatingAccount".tr(),
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.grey58,
                              fontSize: isTablet(context) ? 12.sp : 14.sp,
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
                              BlocProvider.of<AuthBloc>(context).add(
                                  RegisterEvent(phone: "998${phoneController.text.trim().replaceAll(" ", "")}")
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
