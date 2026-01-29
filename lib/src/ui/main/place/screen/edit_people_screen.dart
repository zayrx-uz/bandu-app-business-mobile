import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

class EditPlaceScreen extends StatefulWidget {
  const EditPlaceScreen({
    super.key,
    required this.id,
    this.number,
    required this.name,
    this.employeeIds,
  });
  final int id;
  final int? number;
  final String name;
  final List<int>? employeeIds;

  @override
  State<EditPlaceScreen> createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  bool isActive = false;
  int number = 0;
  String? selectedItem;
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
    number = widget.number ?? 0;
    nameController.text = widget.name;
    if (number > 0) {
      int index = n.indexOf(number);
      if (index != -1) {
        selectedItem = item[index];
      }
    }
    nameController.addListener(check);
    if (widget.employeeIds != null && widget.employeeIds!.isNotEmpty) {
      selectedEmployeeIds = Set<int>.from(widget.employeeIds!);
    }
    BlocProvider.of<HomeBloc>(context).add(GetEmployeeEvent());
  }

  void check() {
    isActive = nameController.text.trim().isNotEmpty && number != 0;
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
      listenWhen: (prev , cur){
        return prev != cur;
      },
      listener: (context, state) {
        if (state is GetEmployeeSuccessState) {
          setState(() {
            employees = state.data;
            if (widget.employeeIds != null && widget.employeeIds!.isNotEmpty) {
              selectedEmployeeIds = Set<int>.from(widget.employeeIds!);
            }
          });
        }
        if (state is UpdatePlaceSuccessState) {
          AppService.successToast(context, "placeUpdated".tr());
          Navigator.pop(context);
        }
        if (state is DeletePlaceSuccessState) {
          AppService.successToast(context, "placeDeleted".tr());
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
                          child: Text("editPlace".tr(), style: AppTextStyle.f600s18),
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
                      initialItem: selectedItem,
                      items: item,
                      onSelect: (value) {
                        number = n[item.indexWhere((e) => e == value)];
                        check();
                      },
                      onAddNew: (value) {
                        try {
                          final countText = value.trim().split(' ')[0];
                          final count = int.parse(countText);
                          if (count > 0) {
                            setState(() {
                              n.add(count);
                              item.add("$count ${"people".tr()}");
                            });
                            number = count;
                            check();
                          }
                        } catch (e) {
                        }
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
                  CacheService.getString("user_role") == "BUSINESS_OWNER" ||  CacheService.getString("user_role") == "MANAGER"  ? Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onTap: () {
                            if (number != 0 && nameController.text.trim().isNotEmpty) {
                              BlocProvider.of<HomeBloc>(context).add(
                                UpdatePlaceEvent(
                                  id: widget.id,
                                  number: number,
                                  name: nameController.text.trim(),
                                  employeeIds: selectedEmployeeIds.toList(),
                                ),
                              );
                            }
                          },
                          text: "edit".tr(),
                          loading: state is UpdatePlaceLoadingState,
                          txtColor:
                          (number != 0 && nameController.text.trim().isNotEmpty) ? AppColor.white : AppColor.greyA7,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: (){
                          if (state is! DeletePlaceLoadingState) {
                            CenterDialog.deletePlaceDialog(
                              context,
                              placeId: widget.id,
                              onDelete: () {
                                BlocProvider.of<HomeBloc>(context).add(
                                  DeletePlaceEvent(
                                    id: widget.id,
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: state is DeletePlaceLoadingState ? CupertinoActivityIndicator() : SvgPicture.asset(
                              AppIcons.trash,
                              width: 24.w,
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w)
                    ],
                  ) : SizedBox(),
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