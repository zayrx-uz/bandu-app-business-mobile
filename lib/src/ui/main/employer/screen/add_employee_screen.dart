import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/auth/input_password_widget.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/select_role_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = "";
  bool isManager = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetMeEvent());

    nameController.addListener(_onInputChanged);
    phoneController.addListener(_onInputChanged);
    passwordController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {});
  }

  bool get _isFormValid {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text.length >= 6 &&
        role.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetMeSuccessState) {
          final userRoles = state.data.data.user.roles;
          final isUserManager = userRoles.contains("MANAGER");
          if (mounted) {
            setState(() {
              isManager = isUserManager;
              if (isUserManager) {
                role = "Worker";
              }
            });
          }
        }
        if (state is SaveEmployeeSuccessState) {
          AppService.successToast(context, "employeeAdded".tr());
          Navigator.pop(context);
        } else if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        bool loading = state is SaveEmployeeLoadingState;
        return Material(
          child: GestureDetector(
            onTap: () {
              AppService.closeKeyboard(context);
            },
            child: Container(
              color: AppColor.white,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "addEmployee".tr(),
                                  style: AppTextStyle.f600s18,
                                ),
                              ),
                              AppIconButton(
                                icon: AppIcons.close,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 0.5.h,
                          width: MediaQuery.of(context).size.width,
                          color: AppColor.greyE5,
                        ),
                        SizedBox(height: 20.h),
                        InputWidget(
                          controller: nameController,
                          title: "employeeName".tr(),
                          hint: "employeeName".tr(),
                        ),
                        SizedBox(height: 12.h),
                        InputPhoneWidget(controller: phoneController),
                        SizedBox(height: 12.h),
                        InputPasswordWidget(
                          controller: passwordController,
                          showValidation: true,
                        ),
                        SizedBox(height: 12.h),
                        SelectRoleWidget(
                          excludeOwnerAndModerator: !isManager,
                          onlyWorker: isManager,
                          initialRole: role.isNotEmpty ? role : null,
                          role: (d) {
                            setState(() {
                              role = d;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    onTap: _isFormValid
                        ? () {
                      BlocProvider.of<HomeBloc>(context).add(
                        SaveEmployeeEvent(
                          name: nameController.text,
                          phone: "998${phoneController.text}",
                          password: passwordController.text,
                          role: role.replaceAll(" ", "_").toUpperCase(),
                        ),
                      );
                    }
                        : () {
                      CenterDialog.errorDialog(
                        context,
                        "pleaseFillAllFields".tr(),
                      );
                    },
                    loading: loading,
                    isGradient: _isFormValid,
                    text: "save".tr(),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}