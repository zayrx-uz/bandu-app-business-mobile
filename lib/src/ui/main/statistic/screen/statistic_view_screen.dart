import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/statistic/statistic_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticViewScreen extends StatefulWidget {
  const StatisticViewScreen({super.key});

  @override
  State<StatisticViewScreen> createState() => _StatisticViewScreenState();
}

class _StatisticViewScreenState extends State<StatisticViewScreen> {
  int selectedIndex = 2;
  int maxIndex = 0;
  StatisticItemData? data;

  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  final List<double> incomes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(
      context,
    ).add(GetStatisticEvent(date: DateTime.now(), period: "yearly"));
    super.initState();
  }

  double get average => incomes.reduce((a, b) => a + b) / incomes.length;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetStatisticSuccessState) {
          data = state.data;
          maxIndex = 0;
          for (int i = 0; i < data!.monthlyData.length; i++) {
            incomes[i] = data!.monthlyData[i].revenue.toDouble();
            if (maxIndex < incomes[i]) {
              maxIndex = incomes[i].toInt();
            }
          }
        }
      },
      builder: (context, state) {
        if (data == null) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: AppColor.black,
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
                  child: Row(
                    children: [
                      // Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                      // SizedBox(width: 4),
                      // Text("-3.5%", style: TextStyle(color: Colors.red)),
                      // SizedBox(width: 8),
                      Text("${"lastUpdated".tr()}: ${DateTime.now().toDDMMYYY()}"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  height: 312.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (i) {
                          // final value = i * 1000000;
                          return SizedBox(
                            height: (280.h - 40.h) / 4,
                            child: Center(
                              child: Text(
                                "${5 - i - 1} ${"mln".tr()}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      SizedBox(width: 12.w),

                      // --------------------- SCROLLABLE BAR CHART --------------------------
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),

                          child: SizedBox(
                            width: incomes.length * 54.w,

                            child: BarChart(
                              BarChartData(
                                minY: 0,
                                maxY: 5000000,

                                // No border, no background
                                borderData: FlBorderData(show: false),
                                backgroundColor: Colors.transparent,

                                // grid lines
                                gridData: FlGridData(
                                  drawVerticalLine: false,
                                  horizontalInterval: 1000000,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.grey.shade300,
                                    strokeWidth: 1,
                                  ),
                                ),

                                // bar groups
                                barGroups: List.generate(incomes.length, (i) {
                                  final isSelected = selectedIndex == i;
                                  return BarChartGroupData(
                                    x: i,
                                    groupVertically: true,
                                    barsSpace: 0.w,
                                    barRods: [
                                      BarChartRodData(
                                        toY: incomes[i],
                                        width: 42.w,
                                        borderRadius: BorderRadius.circular(10),
                                        color: !isSelected
                                            ? AppColor.greyF4
                                            : AppColor.yellowFFC,
                                      ),
                                    ],
                                  );
                                }),

                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(),
                                  rightTitles: AxisTitles(),
                                  leftTitles: AxisTitles(),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28.h,
                                      getTitlesWidget: (v, meta) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: Text(
                                            months[v.toInt()],
                                            style: AppTextStyle.f400s14
                                                .copyWith(
                                                  color:
                                                      selectedIndex == v.toInt()
                                                      ? AppColor.black
                                                      : AppColor.grey77,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                // tooltip & selection
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipPadding: const EdgeInsets.all(12),
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                          return BarTooltipItem(
                                            "${"revenue".tr()}\n",
                                            AppTextStyle.f500s16,
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${rod.toY.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ' ')} UZS",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                  ),
                                  touchCallback: (event, response) {
                                    if (response != null &&
                                        response.spot != null &&
                                        event.isInterestedForInteractions) {
                                      setState(() {
                                        selectedIndex =
                                            response.spot!.touchedBarGroupIndex;
                                      });
                                    }
                                  },
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
