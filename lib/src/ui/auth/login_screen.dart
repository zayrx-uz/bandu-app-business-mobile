import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/company/screen/select_company_screen.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorText;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_check);
    passwordController.addListener(_check);
  }

  void _check() {
    final phoneOk = phoneController.text.length == 12;
    final passOk = passwordController.text.length >= 8;
    errorText = null;
    if (isActive != (phoneOk && passOk)) {
      setState(() => isActive = phoneOk && passOk);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();

    return Scaffold(
      backgroundColor: AppColor.white,

      body: Column(
        children: [
          SizedBox(height: isTablet(context) ? 20.h : 40.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButtons(),
              TopAppName(),
              SizedBox(width: 40.w,)
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => AppService.closeKeyboard(context),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    AppService.changePage(
                      context,
                      BlocProvider(
                        create: (_) => HomeBloc(homeRepository: HomeRepository()),
                        child: SelectCompanyScreen(
                          canPop: true,
                        ),
                      ),
                    );
                  } else if (state is AuthErrorState) {
                    errorText = state.message;
                  }
                },
                builder: (context, state) {
                  final isLoading = state is LoginLoadingState;
                  return Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.only(left: isTablet(context) ? 30.w : 16.w),
                          child: Text("Login", style: AppTextStyle.f600s24.copyWith(
                            fontSize: isTablet(context) ? 18.sp : 24.sp
                          )),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(left: isTablet(context) ? 30.w : 16.w),
                          child: Text(
                            "Enter your email and password to log in.",
                            style: AppTextStyle.f400s16.copyWith(
                              color: AppColor.grey58,
                              fontSize: isTablet(context) ? 12.sp : 16.sp
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        InputPhoneWidget(controller: phoneController),
                        SizedBox(height: 12.h),
                        InputPasswordWidget(controller: passwordController),
                        SizedBox(height: 8.h),
                        if (errorText != null)
                          Container(
                            margin: EdgeInsets.only(left: 16.w),
                            child: Text(
                              errorText!,
                              style: AppTextStyle.f400s16.copyWith(
                                color: AppColor.redED,
                              ),
                            ),
                          ),
                        const Spacer(),
                        AppButton(
                          text: "Login",
                          onTap: () {
                            if (isActive) {
                              bloc.add(
                                LoginEvent(
                                  phone:
                                      "998${phoneController.text.replaceAll(" ", "")}",
                                  password: passwordController.text,
                                  role: widget.role,
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
