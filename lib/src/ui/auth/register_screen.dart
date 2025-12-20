import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/auth/otp_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/select_role_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  String role = '';
  XFile? img;
  String? errorText;


  bool isActive = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(check);
    phoneController.addListener(check);
    confirmController.addListener(check);
  }

  void check() {
    setState(() {
      isActive =
          phoneController.text.length == 12 &&
          passwordController.text.length >= 8 &&
          confirmController.text.length >= 8 &&
          role != "" &&
          confirmController.text == passwordController.text &&
          img != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GetImageSuccessState) {
            img = state.img;
            check();
          } else if (state is RegisterSuccessState) {
            AppService.changePage(
              context,
              OtpScreen(
                otpToken: state.otpToken,
                phoneNumber: phoneController.text,
              ),
            );
          } else if (state is AuthErrorState) {
            errorText = state.message;
          }
        },
        builder: (context, state) {
          bool loading = state is RegisterLoadingState;
          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              leadingWidth: 56.w,
              leading: const BackButtons(),
              backgroundColor: AppColor.white,
              title: TopAppName(fontSize: 28.sp),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text("Register", style: AppTextStyle.f600s24),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "Start creating your Bandu account.",
                      style: AppTextStyle.f400s16.copyWith(
                        color: AppColor.grey58,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SetImageWidget(img: img),
                  SizedBox(height: 12.h),
                  SelectRoleWidget(
                    role: (r) {
                      role = r.replaceAll(" ", "_").toUpperCase();
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 12.h),
                  InputWidget(
                    controller: nameController,
                    title: "Full Name",
                    hint: "Ex. Alisher Dostonov",
                  ),
                  SizedBox(height: 12.h),
                  InputPhoneWidget(controller: phoneController),
                  SizedBox(height: 12.h),
                  InputPasswordWidget(controller: passwordController),
                  SizedBox(height: 12.h),
                  InputPasswordWidget(
                    controller: confirmController,
                    title: "Confirm Password",
                  ),
                  if (errorText != null)
                    Container(
                      margin: EdgeInsets.only(top: 8.h, left: 16.w),
                      child: Text(
                        errorText!,
                        style: AppTextStyle.f400s16.copyWith(
                          color: AppColor.redED,
                        ),
                      ),
                    ),
                  SizedBox(height: 32.h),
                  AppButton(
                    text: "Register",
                    isGradient: isActive,
                    loading: loading,
                    backColor: isActive ? null : AppColor.greyE5,
                    txtColor: isActive ? null : AppColor.greyA7,
                    onTap: () {
                      if (isActive) {
                        if (confirmController.text == passwordController.text) {
                          context.read<AuthBloc>().add(
                            RegisterEvent(
                              phone:
                                  "998${phoneController.text.replaceAll(" ", "")}",
                              fullName: nameController.text,
                              password: passwordController.text,
                              img: img!.path,
                              role: role,
                            ),
                          );
                        }
                      }
                    },
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
