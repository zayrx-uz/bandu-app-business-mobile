import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/ui/onboard/turn_on_notification.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.token});
  final String token;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateButtonState);
    password1.addListener(_updateButtonState);
    password2.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    nameController.removeListener(_updateButtonState);
    password1.removeListener(_updateButtonState);
    password2.removeListener(_updateButtonState);
    nameController.dispose();
    password1.dispose();
    password2.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  bool get _isButtonActive {
    return password1.text == password2.text &&
        nameController.text.isNotEmpty &&
        password2.text.length >= 6 &&
        password1.text.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is RegisterCompleteSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TurnOnNotification()), (route) => false);
          }
          if(state is AuthErrorState){
            CenterDialog.errorDialog(context, state.message);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                loading: state is RegisterCompleteLoadingState,
                text: "register".tr(),
                onTap: () {
                  if(_isButtonActive){
                    BlocProvider.of<AuthBloc>(context).add(
                        RegisterCompleteEvent(role: "BUSINESS_OWNER", fullName: nameController.text, token:widget.token, password: password1.text)
                    );
                  }
                },
                isGradient: _isButtonActive,
                backColor: AppColor.greyE5,
                txtColor: _isButtonActive ? Colors.white : AppColor.greyA7,
              ),
              SizedBox(height: 30.h),
            ],
          );
        },
      ),
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
                      "setPassword".tr(),
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
                      "createPasswordDescription".tr(),
                      style: AppTextStyle.f400s16.copyWith(
                        color: AppColor.grey58,
                        fontSize: isTablet(context) ? 12.sp : 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  InputWidget(
                    controller: nameController,
                    hint: "fullNameHint".tr(),
                    title: "fullName".tr(),
                  ),
                  SizedBox(height: 12.h),

                  InputPasswordWidget(
                    controller: password1,
                    showValidation: true,
                  ),
                  SizedBox(height: 12.h),
                  InputPasswordWidget(
                    controller: password2,
                    showMatchValidation: true,
                    compareController: password1,
                  ),
                  Spacer(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
