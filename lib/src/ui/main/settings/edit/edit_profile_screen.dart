import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/select_gender_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final format = MaskTextInputFormatter(
  mask: '##/##/####',
  filter: {"#": RegExp(r'[0-9]')},
);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool? isMale;
  XFile? img;
  String networkImage = "";
  String? errorText;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(GetMeEvent());
    phoneController.addListener(check);
    nameController.addListener(check);
    confirmController.addListener(check);
    passwordController.addListener(check);
  }

  void check() {
    setState(() {
      isActive =
          nameController.text.trim().length >= 3 &&
          confirmController.text == passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (a, b) {
        RxBus.post(tag: "settings", 2);
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetImageSuccessState) {
            img = state.img;
            check();
          } else if (state is GetMeSuccessState) {
            nameController.text = state.data.data.user.fullName;
            phoneController.text = state.data.data.phoneNumber.replaceAll(
              "998",
              "",
            );
            birthController.text = state.data.data.user.birthDate
                .formatBirthdate();
            isMale = state.data.data.user.gender == "MALE";
            networkImage = state.data.data.user.profilePicture;
          } else if (state is HomeErrorState) {
            errorText = state.message;
          } else if (state is UserUpdateSuccessState) {
            AppService.successToast(context, "Edited");
          }
        },
        builder: (context, state) {
          bool loading = state is UserUpdateLoadingState;
          errorText = null;
          return Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                TopBarWidget(
                  isBack: true,
                  isAppName: false,
                  text: "Edit Profile",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        SetImageWidget(
                          img: img,
                          networkImage: networkImage,
                          isHome: true,
                        ),
                        SizedBox(height: 12.h),
                        InputPhoneWidget(controller: phoneController),
                        SizedBox(height: 12.h),
                        InputWidget(
                          controller: nameController,
                          title: "Full Name",
                          hint: "Ex. Alisher Dostonov",
                        ),
                        SizedBox(height: 12.h),
                        InputWidget(
                          controller: birthController,
                          title: "Birthday",
                          hint: "01/01/2000",
                          format: [format],
                          rightIcon: AppIcons.calendar,
                        ),
                        SizedBox(height: 12.h),
                        InputPasswordWidget(controller: passwordController),
                        SizedBox(height: 12.h),
                        InputPasswordWidget(
                          controller: confirmController,
                          title: "Confirm Password",
                        ),
                        SizedBox(height: 12.h),
                        SelectGenderWidget(
                          isMale: isMale,
                          onTap: (s) {
                            setState(() {
                              isMale = s;
                            });
                          },
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
                      ],
                    ),
                  ),
                ),
                AppButton(
                  text: "Save",
                  isGradient: isActive,
                  loading: loading,
                  backColor: isActive ? null : AppColor.greyE5,
                  txtColor: isActive ? null : AppColor.greyA7,
                  onTap: () {
                    if (confirmController.text == passwordController.text) {
                      final data = UserUpdateModel(
                        fullName: nameController.text,
                        birthDate: birthController.text,
                        gender: isMale!,
                        profilePicture: img != null ? img!.path : networkImage,
                        phoneNumber: "998${phoneController.text}",
                        password: passwordController.text,
                      );

                      BlocProvider.of<HomeBloc>(
                        context,
                      ).add(UserUpdateEvent(data: data));
                    }
                  },
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
