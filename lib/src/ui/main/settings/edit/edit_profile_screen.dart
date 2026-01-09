import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/custom_date_picker.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/select_gender_widget.dart';
import 'package:bandu_business/src/widget/auth/set_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool? isMale;
  XFile? img;
  String networkImage = "";
  String? errorText;
  bool isActive = false;
  bool isLoadingData = true;
  bool shouldCloseAfterRefresh = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(GetMeEvent());
    phoneController.addListener(check);
    nameController.addListener(check);
    firstNameController.addListener(check);
    lastNameController.addListener(check);
    confirmController.addListener(check);
    passwordController.addListener(check);
  }

  @override
  void dispose() {
    nameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    birthController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void check() {
    setState(() {
      final hasName = nameController.text.trim().length >= 3;
      final passwordsMatch = passwordController.text.isEmpty ||
          (passwordController.text == confirmController.text &&
              passwordController.text.length >= 6);
      isActive = hasName && passwordsMatch;
    });
  }

  Future<void> _selectDate() async {
    DateTime? initialDate;
    if (birthController.text.isNotEmpty) {
      try {
        final parts = birthController.text.split("/");
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }
    initialDate ??= DateTime.now().subtract(Duration(days: 365 * 18));

    final selectedDate = await CustomDatePicker.showDatePickerDialog(
      context,
      initialDate: initialDate,
      maximumDate: DateTime.now(),
    );

    if (selectedDate != null) {
      final day = selectedDate.day.toString().padLeft(2, '0');
      final month = selectedDate.month.toString().padLeft(2, '0');
      final year = selectedDate.year.toString();
      birthController.text = "$day/$month/$year";
      check();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (a, b) {
        RxBus.post(tag: "settings", 2);
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetMeLoadingState) {
            setState(() {
              isLoadingData = true;
            });
          } else if (state is GetImageSuccessState) {
            setState(() {
              img = state.img;
              networkImage = "";
            });
            check();
          } else if (state is HomeErrorState) {
            setState(() {
              errorText = state.message;
              isLoadingData = false;
            });
          } else if (state is UserUpdateSuccessState) {
            setState(() {
              shouldCloseAfterRefresh = true;
            });
            AppService.successToast(context, "edited".tr());
          } else if (state is GetMeSuccessState) {
            final user = state.data.data.user;
            final phoneData = state.data.data.phoneNumber;
            
            setState(() {
              nameController.text = user.fullName;
              firstNameController.text = user.firstName.isNotEmpty ? user.firstName : "";
              lastNameController.text = user.lastName.isNotEmpty ? user.lastName : "";
              phoneController.text = phoneData.replaceAll("998", "").replaceAll("+", "");
              
              if (user.birthDate.isNotEmpty) {
                try {
                  birthController.text = user.birthDate.formatBirthdate();
                } catch (_) {
                  birthController.text = "";
                }
              } else {
                birthController.text = "";
              }
              
              isMale = user.gender == "MALE";
              networkImage = user.profilePicture;
              isLoadingData = false;
            });
            check();
            
            if (shouldCloseAfterRefresh) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  Navigator.pop(context);
                  RxBus.post(tag: "settings", 2);
                }
              });
            }
          } else if (state is UserUpdateLoadingState) {
            setState(() {
              errorText = null;
            });
          }
        },
        builder: (context, state) {
          final bool loading = state is UserUpdateLoadingState;
          final bool gettingData = state is GetMeLoadingState || isLoadingData;
          
          return Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                TopBarWidget(
                  isBack: true,
                  isAppName: false,
                  text: "editProfile".tr(),
                ),
                Expanded(
                  child: gettingData
                      ? Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: AppColor.black,
                          ),
                        )
                      : SingleChildScrollView(
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
                                title: "fullName".tr(),
                                hint: "fullNameHint".tr(),
                              ),
                              SizedBox(height: 12.h),
                              InputWidget(
                                controller: firstNameController,
                                title: "firstName".tr(),
                                hint: "firstNameHint".tr(),
                              ),
                              SizedBox(height: 12.h),
                              InputWidget(
                                controller: lastNameController,
                                title: "lastName".tr(),
                                hint: "lastNameHint".tr(),
                              ),
                              SizedBox(height: 12.h),
                              GestureDetector(
                                onTap: _selectDate,
                                child: InputWidget(
                                  controller: birthController,
                                  title: "birthday".tr(),
                                  hint: "birthdayHint".tr(),
                                  format: [format],
                                  rightIcon: AppIcons.calendar,
                                  readOnly: true,
                                  onRightIconTap: _selectDate,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              InputPasswordWidget(controller: passwordController),
                              SizedBox(height: 12.h),
                              InputPasswordWidget(
                                controller: confirmController,
                                title: "confirmPassword".tr(),
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
                  text: "save".tr(),
                  isGradient: isActive && !gettingData,
                  loading: loading,
                  backColor: isActive && !gettingData ? null : AppColor.greyE5,
                  txtColor: isActive && !gettingData ? null : AppColor.greyA7,
                  onTap: () {
                    if (loading || gettingData) return;
                    
                    if (passwordController.text.isNotEmpty &&
                        passwordController.text != confirmController.text) {
                      setState(() {
                        errorText = "passwordsDoNotMatch".tr();
                      });
                      return;
                    }

                    if (passwordController.text.isNotEmpty &&
                        passwordController.text.length < 6) {
                      setState(() {
                        errorText = "passwordMustBeAtLeast6Characters".tr();
                      });
                      return;
                    }

                    final data = UserUpdateModel(
                      fullName: nameController.text.trim(),
                      firstName: firstNameController.text.trim().isNotEmpty
                          ? firstNameController.text.trim()
                          : null,
                      lastName: lastNameController.text.trim().isNotEmpty
                          ? lastNameController.text.trim()
                          : null,
                      birthDate: birthController.text.trim().isNotEmpty
                          ? birthController.text.trim()
                          : null,
                      gender: isMale != null
                          ? (isMale! ? "MALE" : "FEMALE")
                          : null,
                      profilePicture:
                          img != null ? img!.path : (networkImage.isNotEmpty ? networkImage : ""),
                      phoneNumber: "998${phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')}",
                      password: passwordController.text.trim().isNotEmpty
                          ? passwordController.text.trim()
                          : null,
                    );

                    BlocProvider.of<HomeBloc>(context).add(
                      UserUpdateEvent(data: data),
                    );
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
