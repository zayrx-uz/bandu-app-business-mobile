import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/auth/input_phone_widget.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/auth/select_role_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  const UpdateEmployeeScreen({super.key, required this.data});
  final EmployeeItemData data;

  @override
  State<UpdateEmployeeScreen> createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String role = "";

  // Helper function to convert API role format to display format
  String _convertRoleToDisplay(String apiRole) {
    return apiRole.replaceAll("_", " ").split(" ").map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(" ");
  }

  // Helper function to get first role from list or empty string
  String _getFirstRole(List<String> roles) {
    if (roles.isEmpty) return "";
    return _convertRoleToDisplay(roles.first);
  }

  @override
  void initState() {
    super.initState();

    nameController.text = widget.data.fullName;
    role = _getFirstRole(widget.data.roles);

    // 1. Raqamni olish (+998 ni kesish)
    String rawPhone = widget.data.authProviders.first.phoneNumber;
    if (rawPhone.startsWith("+998")) {
      rawPhone = rawPhone.substring(4);
    } else if (rawPhone.startsWith("998")) {
      rawPhone = rawPhone.substring(3);
    }

    // 2. MUHIM: Global maskani tozalab, yangi qiymatni formatlab beramiz
    // Bu maskani controllerga o'rnatishdan oldin uning ichki holatini yangilaydi
    phoneController.text = uzPhoneMask.maskText(rawPhone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is UpdateEmployeeSuccessState) {
          AppService.successToast(context, "employeeUpdated".tr());
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
                                  "updateEmployee".tr(),
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
                        SelectRoleWidget(
                          role: (d) {
                            role = d;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    onTap: () {
                      if (nameController.text.isEmpty ||
                          role.isEmpty ||
                           phoneController.text.isEmpty) {
                        CenterDialog.errorDialog(
                          context,
                          "pleaseFillAllFields".tr(),
                        );
                        return;
                      } else {
                        BlocProvider.of<HomeBloc>(context).add(
                          UpdateEmployeeEvent(
                            name: nameController.text,
                            phone: "998${phoneController.text}",
                            id: widget.data.id,
                            role: role.replaceAll(" ", "_").toUpperCase(),
                          ),
                        );
                      }
                    },
                    loading: loading,
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
