import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/statistic/statistic_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticViewScreen extends StatefulWidget {
  const StatisticViewScreen({super.key});

  @override
  State<StatisticViewScreen> createState() => _StatisticViewScreenState();
}

class _StatisticViewScreenState extends State<StatisticViewScreen> {
  int selectedIndex = -1;
  StatisticItemData? data;
  final ScrollController _scrollController = ScrollController();

  final List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];
  final List<double> incomes = List.filled(12, 0.0);

  static const double _maxY = 5000000;
  static const double _interval = 500000;
  final double _itemWidth = 54.w;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(
      GetStatisticEvent(date: DateTime.now(), period: "yearly"),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentMonth() {
    final now = DateTime.now();
    final currentIndex = now.month - 1;

    setState(() {
      selectedIndex = currentIndex;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final screenWidth = MediaQuery.of(context).size.width - 70.w;
        final scrollOffset = (currentIndex * _itemWidth) - (screenWidth / 2) + (_itemWidth / 2);

        _scrollController.animateTo(
          scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetStatisticSuccessState) {
          data = state.data;
          if (data!.monthlyData != null) {
            for (int i = 0; i < data!.monthlyData!.length; i++) {
              if (i < 12) {
                incomes[i] = data!.monthlyData![i].revenue.toDouble();
              }
            }
          }
          _scrollToCurrentMonth();
        }
      },
      builder: (context, state) {
        if (data == null) {
          return const Material(
            child: Center(
              child: CupertinoActivityIndicator(color: AppColor.black),
            ),
          );
        }
        return Material(
          child: Container(
            color: AppColor.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("cashFlow".tr(), style: AppTextStyle.f600s18),
                      ),
                      AppIconButton(
                        icon: AppIcons.close,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 0.5.h,
                  width: 1.sw,
                  color: AppColor.greyE5,
                ),
                SizedBox(height: 12.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "${data!.totalRevenue.priceFormat()} UZS",
                    style: AppTextStyle.f600s24,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "${"lastUpdated".tr()}: ${DateTime.now().toDDMMYYY()}",
                    style: AppTextStyle.f400s14.copyWith(color: AppColor.grey77),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  height: 312.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(11, (i) {
                          final value = (5.0 - (i * 0.5));
                          return SizedBox(
                            height: (280.h - 40.h) / 10,
                            child: Center(
                              child: Text(
                                "${value % 1 == 0 ? value.toInt() : value} mln",
                                style: TextStyle(fontSize: 10.sp, color: AppColor.grey77),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            width: incomes.length * _itemWidth,
                            child: BarChart(
                              BarChartData(
                                minY: 0,
                                maxY: _maxY,
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  drawVerticalLine: false,
                                  horizontalInterval: _interval,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: AppColor.greyE5,
                                    strokeWidth: 1,
                                  ),
                                ),
                                barGroups: List.generate(incomes.length, (i) {
                                  return BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: incomes[i].clamp(0.0, _maxY),
                                        width: 38.w,
                                        borderRadius: BorderRadius.circular(8.r),
                                        color: selectedIndex == i
                                            ? AppColor.yellowFFC
                                            : AppColor.greyF4,
                                      ),
                                    ],
                                  );
                                }),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(),
                                  rightTitles: const AxisTitles(),
                                  leftTitles: const AxisTitles(),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30.h,
                                      getTitlesWidget: (v, meta) {
                                        int index = v.toInt();
                                        if (index >= 0 && index < months.length) {
                                          return Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Text(
                                              months[index],
                                              style: AppTextStyle.f400s12.copyWith(
                                                color: selectedIndex == index
                                                    ? AppColor.black
                                                    : AppColor.grey77,
                                                fontWeight: selectedIndex == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                ),
                                barTouchData: BarTouchData(
                                  touchCallback: (event, response) {
                                    if (response != null &&
                                        response.spot != null &&
                                        event is FlTapUpEvent) {
                                      setState(() {
                                        selectedIndex = response.spot!.touchedBarGroupIndex;
                                      });
                                    }
                                  },
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      return BarTooltipItem(
                                        "${incomes[groupIndex].toInt().priceFormat()} UZS",
                                        TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}