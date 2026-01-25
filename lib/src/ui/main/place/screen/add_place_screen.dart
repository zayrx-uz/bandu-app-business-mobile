import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/auth/input_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:bandu_business/src/widget/main/place/select_people_count_widget.dart';
import 'package:bandu_business/src/widget/main/place/selectable_employee_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  bool isActive = false;
  int number = 0;
  var n = [1, 2, 4, 6, 8, 12];
  late List<String> item;
  TextEditingController nameController = TextEditingController();
  List<EmployeeItemData>? employees;
  Set<int> selectedEmployeeIds = {};

  @override
  void initState() {
    super.initState();
    item = [
      "1 ${"people".tr()}",
      "2 ${"people".tr()}",
      "4 ${"people".tr()}",
      "6 ${"people".tr()}",
      "8 ${"people".tr()}",
      "12 ${"people".tr()}",
    ];
    nameController.addListener(check);
    BlocProvider.of<HomeBloc>(context).add(GetEmployeeEvent());
  }


  void check() {
    isActive = nameController.text.trim().length >= 3 && number != 0;
    setState(() {});
  }

  void _toggleEmployee(int employeeId) {
    setState(() {
      if (selectedEmployeeIds.contains(employeeId)) {
        selectedEmployeeIds.remove(employeeId);
      } else {
        selectedEmployeeIds.add(employeeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetEmployeeSuccessState) {
          setState(() {
            employees = state.data;
          });
        }
        if (state is SetPlaceSuccessState) {
          AppService.successToast(context, "placeCreated".tr());
          Navigator.pop(context);
        }
        if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        return Material(
          child: GestureDetector(
            onTap: () {
              AppService.closeKeyboard(context);
            },
            child: Container(
              color: AppColor.white,
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "addPlace".tr(),
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
                    title: "placeName".tr(),
                    hint: "placeName".tr(),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 16.w),
                    child: Text(
                      "numberOfPeople".tr(),
                      style: AppTextStyle.f500s16.copyWith(
                        color: AppColor.black09,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SelectPeopleCountWidget(
                      hintText: "enterNumber".tr(),
                      items: item,
                      initialItem: number > 0 ? '$number ${"people".tr()}' : null,
                      onSelect: (value) {
                        try {
                          final countText = value.trim().split(RegExp(r'\s+')).first;
                          final count = int.parse(countText);
                          if (count > 0) {
                            setState(() {
                              number = count;
                            });
                            check();
                          }
                        } catch (_) {
                          final idx = item.indexWhere((e) => e == value);
                          if (idx >= 0 && idx < n.length) {
                            setState(() {
                              number = n[idx];
                            });
                            check();
                          }
                        }
                      },
                      onAddNew: (value) {
                        try {
                          final countText = value.trim().split(RegExp(r'\s+')).first;
                          final count = int.parse(countText);
                          if (count > 0) {
                            setState(() {
                              n.add(count);
                              item.add("$count ${"people".tr()}");
                              number = count;
                            });
                            check();
                          }
                        } catch (_) {}
                      },
                    ),
                  ),
                  if (employees != null && employees!.isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 16.w),
                      child: Text(
                        "selectEmployees".tr(),
                        style: AppTextStyle.f500s16.copyWith(
                          color: AppColor.black09,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: employees!.length,
                        padding: EdgeInsets.only(bottom: 8.h),
                        itemBuilder: (context, index) {
                          final employee = employees![index];
                          return SelectableEmployeeItemWidget(
                            employee: employee,
                            isSelected: selectedEmployeeIds.contains(employee.id),
                            onTap: () => _toggleEmployee(employee.id),
                          );
                        },
                      ),
                    ),
                  ] else if (state is GetEmployeeLoadingState) ...[
                    SizedBox(height: 20.h),
                    Center(
                      child: CupertinoActivityIndicator(
                        color: AppColor.black,
                      ),
                    ),
                    Spacer(),
                  ] else ...[
                    Spacer(),
                  ],

                  AppButton(
                    onTap: () {
                      if (isActive) {
                        BlocProvider.of<HomeBloc>(context).add(
                          SetPlaceEvent(
                            name: nameController.text,
                            number: number,
                            employeeIds: selectedEmployeeIds.toList(),
                          ),
                        );
                      }
                    },
                    isGradient: isActive,
                    backColor: AppColor.greyE5,
                    text: "addPlace".tr(),
                    leftIcon: AppIcons.plus,
                    loading: state is SetPlaceLoadingState,
                    txtColor: isActive ? AppColor.white : AppColor.greyA7,
                    leftIconColor: isActive ? AppColor.white : AppColor.greyA7,
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
