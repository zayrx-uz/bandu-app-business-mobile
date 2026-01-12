import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/create_success.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/ui/onboard/turn_on_notification.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/back_button.dart';
import 'package:bandu_business/src/widget/app/top_app_name.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: "register".tr(),
              onTap: () {
                AppService.changePage(context, TurnOnNotification());
              },
              isGradient: password1.text == password2.text &&
                  nameController.text.isNotEmpty && password2.text.length <= 6 && password1.text.length <= 6,
              backColor: AppColor.greyE5,
              txtColor: password1.text == password2.text &&
                  nameController.text.isNotEmpty && password2.text.length <= 6 && password1.text.length <= 6 ? Colors.white : AppColor.greyA7,
            ),
            SizedBox(height: 30.h,)
          ],
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
                        "Set password",
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
                        "Create a password for yourself to log in. ",
                        style: AppTextStyle.f400s16.copyWith(
                          color: AppColor.grey58,
                          fontSize: isTablet(context) ? 12.sp : 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    InputWidget(controller: nameController,
                      hint: "Full Name",
                      title: "Full Name",),
                    SizedBox(height: 12.h,),

                    InputPasswordWidget(controller: password1, onChange: (v) {
                      setState(() {

                      });
                    },),
                    SizedBox(height: 12.h,),
                    InputPasswordWidget(controller: password2, onChange: (v) {
                      setState(() {

                      });
                    }, ),
                    Spacer(),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
