import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectEmployeeWidget extends StatefulWidget {
  final Function(List<int>)? onEmployeesSelected;
  final List<int>? initialSelectedIds;

  const SelectEmployeeWidget({
    super.key,
    this.onEmployeesSelected,
    this.initialSelectedIds,
  });

  @override
  State<SelectEmployeeWidget> createState() => _SelectEmployeeWidgetState();
}

class _SelectEmployeeWidgetState extends State<SelectEmployeeWidget> {
  List<EmployeeItemData>? employees;
  Set<int> selectedEmployeeIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedIds != null && widget.initialSelectedIds!.isNotEmpty) {
      selectedEmployeeIds = Set.from(widget.initialSelectedIds!);
    }
    _loadEmployees();
  }

  @override
  void didUpdateWidget(SelectEmployeeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelectedIds != widget.initialSelectedIds) {
      if (widget.initialSelectedIds != null && widget.initialSelectedIds!.isNotEmpty) {
        setState(() {
          selectedEmployeeIds = Set.from(widget.initialSelectedIds!);
        });
      }
    }
  }

  void _loadEmployees() {
    context.read<HomeBloc>().add(GetEmployeeEvent());
  }

  void _toggleEmployee(int employeeId) {
    setState(() {
      if (selectedEmployeeIds.contains(employeeId)) {
        selectedEmployeeIds.remove(employeeId);
      } else {
        selectedEmployeeIds.add(employeeId);
      }
      if (widget.onEmployeesSelected != null) {
        widget.onEmployeesSelected!(selectedEmployeeIds.toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetEmployeeSuccessState) {
          setState(() {
            employees = state.data;
            if (widget.initialSelectedIds != null && widget.initialSelectedIds!.isNotEmpty) {
              selectedEmployeeIds = Set.from(widget.initialSelectedIds!);
            }
          });
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is GetEmployeeLoadingState && employees == null) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.yellowFFC,
                ),
              ),
            );
          }

          if (employees == null || employees!.isEmpty) {
            return SizedBox.shrink();
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "selectEmployees".tr(),
                  style: AppTextStyle.f500s16.copyWith(
                    color: AppColor.black09,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 200.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColor.greyFA,
                    border: Border.all(
                      width: 1.h,
                      color: AppColor.greyE5,
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: employees!.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final employee = employees![index];
                      final isSelected = selectedEmployeeIds.contains(employee.id);
                      return GestureDetector(
                        onTap: () => _toggleEmployee(employee.id),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.yellowFFC.withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                width: index < employees!.length - 1 ? 1.h : 0,
                                color: AppColor.greyE5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2.h,
                                    color: isSelected
                                        ? AppColor.yellowFFC
                                        : AppColor.greyE5,
                                  ),
                                  color: isSelected
                                      ? AppColor.yellowFFC
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 14.sp,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12.w),
                              CustomNetworkImage(
                                imageUrl: employee.profilePicture,
                                height: 32.h,
                                width: 32.h,
                                borderRadius: 100,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.fullName,
                                      style: AppTextStyle.f500s16,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      employee.roles.isNotEmpty 
                                          ? employee.roles.first.toUpperCase() 
                                          : "",
                                      style: AppTextStyle.f400s12.copyWith(
                                        color: AppColor.grey58,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (selectedEmployeeIds.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      "${selectedEmployeeIds.length} ${"selected".tr()}",
                      style: AppTextStyle.f400s14.copyWith(
                        color: AppColor.grey58,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
