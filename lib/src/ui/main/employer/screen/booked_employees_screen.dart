import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_employees_booked_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/employer/booked_employee_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookedEmployeesScreen extends StatefulWidget {
  const BookedEmployeesScreen({super.key});

  @override
  State<BookedEmployeesScreen> createState() => _BookedEmployeesScreenState();
}

class _BookedEmployeesScreenState extends State<BookedEmployeesScreen> {
  DashboardEmployeesBookedData? data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    final companyId = HelperFunctions.getCompanyId();
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final clientDateTime = now.toIso8601String();
    
    BlocProvider.of<HomeBloc>(context).add(
      GetBookedEmployeesEvent(
        companyId: companyId,
        date: formattedDate,
        clientDateTime: clientDateTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetBookedEmployeesSuccessState) {
            data = state.data;
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is GetBookedEmployeesLoadingState && data == null) {
            return Column(
              children: [
                TopBarWidget(
                  isBack: true,
                ),
                Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.black,
                    ),
                  ),
                ),
              ],
            );
          }
          
          if (state is HomeErrorState && data == null) {
            return Column(
              children: [
                TopBarWidget(
                  isBack: true,
                ),
                Expanded(
                  child: Center(
                    child: EmptyWidget(text: state.message),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              TopBarWidget(isBack: true),
              if (data != null && _hasEmployees(data!))
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getData();
                      await Future.delayed(Duration(milliseconds: 500));
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < data!.groups.length; i++)
                            if (data!.groups[i].employees.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (i > 0) SizedBox(height: 20.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      data!.groups[i].groupName,
                                      style: AppTextStyle.f600s16,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  for (int j = 0; j < data!.groups[i].employees.length; j++)
                                    BookedEmployeeItemWidget(
                                      employee: data!.groups[i].employees[j],
                                    ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (data != null && !_hasEmployees(data!))
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getData();
                      await Future.delayed(Duration(milliseconds: 500));
                    },
                    child: Center(
                      child: EmptyWidget(
                        text: "noBookedEmployeesAvailable".tr(),
                        icon: AppIcons.employe,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  bool _hasEmployees(DashboardEmployeesBookedData data) {
    for (var group in data.groups) {
      if (group.employees.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
