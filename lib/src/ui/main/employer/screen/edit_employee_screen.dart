import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/model/api/main/home/resource_category_model.dart' as resource_category;
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart' as resource_model;
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
  List<int> selectedResourceIds = [];
  resource_model.ResourceModel? resourceData;

  // Helper function to convert API role format to display format
  String _convertRoleToDisplay(String apiRole) {
    final normalized = apiRole.replaceAll("_", " ").toUpperCase();
    if (normalized == "WORKER") {
      return "Worker";
    } else if (normalized == "MANAGER") {
      return "Manager";
    }
    return apiRole.replaceAll("_", " ").split(" ").map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(" ");
  }

  String _getFirstRole(List<String> roles) {
    if (roles.isEmpty) return "";
    return _convertRoleToDisplay(roles.first);
  }

  @override
  void initState() {
    super.initState();

    nameController.text = widget.data.fullName;
    role = _getFirstRole(widget.data.roles);

    String rawPhone = widget.data.authProviders.first.phoneNumber;
    if (rawPhone.startsWith("+998")) {
      rawPhone = rawPhone.substring(4);
    } else if (rawPhone.startsWith("998")) {
      rawPhone = rawPhone.substring(3);
    }

    phoneController.text = uzPhoneMask.maskText(rawPhone);
    
    final companyId = HelperFunctions.getCompanyId();
    if (companyId != null && companyId > 0) {
      BlocProvider.of<HomeBloc>(context).add(GetResourceEvent(id: companyId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is UpdateEmployeeSuccessState) {
          AppService.successToast(context, "employeeUpdated".tr());
          Navigator.pop(context);
        } else if (state is GetResourceSuccessState) {
          setState(() {
            resourceData = state.data;
          });
        } else if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        bool loading = state is UpdateEmployeeLoadingState;
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
                          initialRole: role.isNotEmpty ? role : null,
                          role: (d) {
                            role = d;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 12.h),
                        InputPasswordWidget(
                          controller: passwordController,
                          title: "password".tr(),
                          hint: "enterPassword".tr(),
                        ),
                        SizedBox(height: 12.h),
                        // if (resourceData != null && resourceData!.data.isNotEmpty)
                        //   Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 16.w),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           "resources".tr(),
                        //           style: AppTextStyle.f500s16,
                        //         ),
                        //         SizedBox(height: 8.h),
                        //         Container(
                        //           constraints: BoxConstraints(maxHeight: 200.h),
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(12.r),
                        //             color: AppColor.greyFA,
                        //             border: Border.all(
                        //               width: 1.h,
                        //               color: AppColor.greyE5,
                        //             ),
                        //           ),
                        //           child: ListView.builder(
                        //             shrinkWrap: true,
                        //             itemCount: resourceData!.data.length,
                        //             itemBuilder: (context, index) {
                        //               final resource = resourceData!.data[index];
                        //               final isSelected = selectedResourceIds.contains(resource.id);
                        //               return GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     if (isSelected) {
                        //                       selectedResourceIds.remove(resource.id);
                        //                     } else {
                        //                       selectedResourceIds.add(resource.id);
                        //                     }
                        //                   });
                        //                 },
                        //                 child: Container(
                        //                   padding: EdgeInsets.symmetric(
                        //                     horizontal: 12.w,
                        //                     vertical: 10.h,
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                     color: isSelected
                        //                         ? AppColor.yellowFFC.withValues(alpha: 0.1)
                        //                         : Colors.transparent,
                        //                     border: Border(
                        //                       bottom: BorderSide(
                        //                         width: index < resourceData!.data.length - 1 ? 1.h : 0,
                        //                         color: AppColor.greyE5,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   child: Row(
                        //                     children: [
                        //                       Expanded(
                        //                         child: Text(
                        //                           resource.name,
                        //                           style: AppTextStyle.f500s14,
                        //                         ),
                        //                       ),
                        //                       if (isSelected)
                        //                         Icon(
                        //                           Icons.check_circle,
                        //                           color: AppColor.yellowFFC,
                        //                           size: 20.w,
                        //                         ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
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
                            phone: "998${phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')}",
                            id: widget.data.id,
                            role: role.replaceAll(" ", "_").toUpperCase(),
                            password: passwordController.text.trim().isNotEmpty
                                ? passwordController.text.trim()
                                : null,
                            resourceIds: selectedResourceIds.isNotEmpty
                                ? selectedResourceIds
                                : null,
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
