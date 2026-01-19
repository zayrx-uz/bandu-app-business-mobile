import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/model/api/main/statistic/statistic_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/main/booking/bookings_screen.dart';
import 'package:bandu_business/src/ui/main/place/screen/empty_places_screen.dart';
import 'package:bandu_business/src/ui/main/place/screen/booked_places_screen.dart';
import 'package:bandu_business/src/ui/main/employer/screen/empty_employees_screen.dart';
import 'package:bandu_business/src/ui/main/employer/screen/booked_employees_screen.dart';
import 'package:bandu_business/src/ui/main/statistic/screen/revenue_statistic_screen.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/statistic/statistic_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  StatisticItemData? data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    BlocProvider.of<HomeBloc>(
      context,
    ).add(GetStatisticEvent(date: DateTime.now(), period: "daily"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetStatisticSuccessState) {
          data = state.data;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
            children: [
              TopBarWidget(),
              if (state is GetStatisticLoadingState && data == null)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: AppColor.black,
                    ),
                  ),
                )
              else if (state is GetStatisticSuccessState && data != null)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getData();
                      await Future.delayed(Duration(milliseconds: 500));
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      StatisticItemWidget(
                        icon: AppIcons.coins,
                        title: "dailyRevenue".tr(),
                        desc: "${data!.totalRevenue.priceFormat()} UZS",
                        onTap: () {
                          CupertinoScaffold.showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BlocProvider(
                                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                                child: const RevenueStatisticScreen(),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.users,
                        title: "incomingCustomers".tr(),
                        desc: data!.totalCustomers.toString(),
                        onTap: () {
                          AppService.changePage(
                            context,
                            BlocProvider(
                              create: (_) => HomeBloc(homeRepository: HomeRepository()),
                              child: const BookingsScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.shop,
                        title: "occupiedPlaces".tr(),
                        desc: data!.totalPlaces.toString(),
                        onTap: () {
                          AppService.changePage(
                            context,
                            BlocProvider(
                              create: (_) => HomeBloc(homeRepository: HomeRepository()),
                              child: const BookedPlacesScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.shop,
                        title: "availablePlaces".tr(),
                        desc: data!.totalEmptyPlaces.toString(),
                        onTap: () {
                          AppService.changePage(
                            context,
                            BlocProvider(
                              create: (_) => HomeBloc(homeRepository: HomeRepository()),
                              child: const EmptyPlacesScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.employe,
                        title: "totalEmployees".tr(),
                        desc: data!.employeesTotalCount.toString(),
                        onTap: () {
                          RxBus.post(2, tag: "CHANGE_TAB");
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.employe,
                        title: "bookedEmployees".tr(),
                        desc: data!.employeesBookedNowCount.toString(),
                        onTap: () {
                          AppService.changePage(
                            context,
                            BlocProvider(
                              create: (_) => HomeBloc(homeRepository: HomeRepository()),
                              child: const BookedEmployeesScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatisticItemWidget(
                        icon: AppIcons.employe,
                        title: "availableEmployees".tr(),
                        desc: data!.employeesEmptyNowCount.toString(),
                        onTap: () {
                          AppService.changePage(
                            context,
                            BlocProvider(
                              create: (_) => HomeBloc(homeRepository: HomeRepository()),
                              child: const EmptyEmployeesScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      if( data!.newCustomers.isNotEmpty )
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColor.white,
                            border: Border.all(
                              width: 1.h,
                              color: AppColor.greyE5,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40.h,
                                      width: 40.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        color: AppColor.greyFA,
                                        border: Border.all(
                                          width: 1.h,
                                          color: AppColor.greyE5,
                                        ),
                                      ),
                                      child: Center(
                                        child: AppSvgAsset(
                                          AppIcons.users,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Text(
                                        "newCustomers".tr(),
                                        style: AppTextStyle.f500s16
                                            .copyWith(
                                          color: AppColor.grey58,
                                        ),
                                      ),
                                    ),
                                    AppIconButton(
                                      height: 40.h,
                                      width: 40.h,
                                      icon: AppIcons.filter,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                color: AppColor.greyFA,
                                child: Row(
                                  children: [
                                    Text(
                                      "fullName".tr(),
                                      style: AppTextStyle.f500s14.copyWith(
                                        color: AppColor.grey58,
                                      ),
                                    ),
                                    SizedBox(width: 64.w),
                                    Text(
                                      "phoneNumber".tr(),
                                      style: AppTextStyle.f500s14.copyWith(
                                        color: AppColor.grey58,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for (
                              int i = 0;
                              i < data!.newCustomers.length;
                              i++
                              )
                                Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data!.newCustomers[i].fullName,
                                        maxLines: 1,

                                        style: AppTextStyle.f500s14,
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "99 130 30 35",
                                          style: AppTextStyle.f500s14
                                              .copyWith(
                                            decoration: TextDecoration
                                                .underline,
                                          ),
                                        ),
                                      ),
                                      AppIconButton(
                                        icon: AppIcons.right,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              )
              else if (state is HomeErrorState)
                Expanded(
                child : Center(
                  child : EmptyWidget(text: state.message)
                )
              )
            ],
          ),
        );
      },
    );
  }
}
