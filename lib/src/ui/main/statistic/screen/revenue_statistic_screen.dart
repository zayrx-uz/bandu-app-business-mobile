import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_revenue_series_model.dart' show DashboardRevenueSeriesData, SeriesItem;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevenueStatisticScreen extends StatefulWidget {
  const RevenueStatisticScreen({super.key});

  @override
  State<RevenueStatisticScreen> createState() => _RevenueStatisticScreenState();
}

class _RevenueStatisticScreenState extends State<RevenueStatisticScreen> {
  int selectedIndex = 0;
  DashboardRevenueSeriesData? data;
  List<double> amounts = [];
  List<SeriesItem> seriesOrdered = [];

  static const double _maxY = 10_000_000;
  static const double _interval = 1_000_000;

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
      GetRevenueSeriesEvent(
        companyId: companyId,
        period: "monthly",
        date: formattedDate,
        clientDateTime: clientDateTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetRevenueSeriesSuccessState) {
          data = state.data;
          amounts = [];
          seriesOrdered = [];

          if (data!.series.isNotEmpty) {
            seriesOrdered = List<SeriesItem>.from(data!.series).reversed.toList();
            for (var item in seriesOrdered) {
              amounts.add(item.amount);
            }
            selectedIndex = 0;
          }
          setState(() {});
        }
      },
      builder: (context, state) {
        if (state is GetRevenueSeriesLoadingState && data == null) {
          return Material(
            child: Container(
              color: AppColor.white,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.black,
                ),
              ),
            ),
          );
        }

        if (data == null) {
          return Material(
            child: Container(
              color: AppColor.white,
              child: Center(
                child: Text("noDataFound".tr()),
              ),
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
                    "${data!.total.amount.toInt().priceFormat()} UZS",
                    style: AppTextStyle.f600s24,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      if (data!.total.changePercent != 0)
                        Row(
                          children: [
                            Icon(
                              data!.total.changePercent > 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: data!.total.changePercent > 0
                                  ? Colors.green
                                  : Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${data!.total.changePercent.toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: data!.total.changePercent > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                      Text(
                        "${"lastUpdated".tr()}: ${data!.lastUpdatedAt != null ? DateTime.tryParse(data!.lastUpdatedAt!)?.toDDMMYYY() ?? DateTime.now().toDDMMYYY() : DateTime.now().toDDMMYYY()}",
                        style: AppTextStyle.f400s14.copyWith(
                          color: AppColor.grey58,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                if (amounts.isNotEmpty)
                  Container(
                    height: 312.h,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(10, (i) {
                            final value = 10 - i;
                            return SizedBox(
                              height: (280.h - 40.h) / 9,
                              child: Center(
                                child: Text(
                                  "$value ${"mln".tr()}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: SizedBox(
                              width: amounts.length * 54.w,
                              child: BarChart(
                                BarChartData(
                                  minY: 0,
                                  maxY: _maxY,
                                  borderData: FlBorderData(show: false),
                                  backgroundColor: Colors.transparent,
                                  gridData: FlGridData(
                                    drawVerticalLine: false,
                                    horizontalInterval: _interval,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.grey.shade300,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  barGroups: List.generate(amounts.length, (i) {
                                    final isSelected = selectedIndex == i;
                                    final clamped = amounts[i].clamp(0.0, _maxY);
                                    return BarChartGroupData(
                                      x: i,
                                      groupVertically: true,
                                      barsSpace: 0.w,
                                      barRods: [
                                        BarChartRodData(
                                          toY: clamped,
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
                                          if (v.toInt() >= 0 && v.toInt() < seriesOrdered.length) {
                                            return Padding(
                                              padding: EdgeInsets.only(top: 8.h),
                                              child: Text(
                                                seriesOrdered[v.toInt()].label,
                                                style: AppTextStyle.f400s14.copyWith(
                                                  color: selectedIndex == v.toInt()
                                                      ? AppColor.black
                                                      : AppColor.grey77,
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
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipPadding: const EdgeInsets.all(8),
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        final value = groupIndex >= 0 && groupIndex < amounts.length
                                            ? amounts[groupIndex].toInt()
                                            : rod.toY.toInt();
                                        return BarTooltipItem(
                                          "${"revenue".tr()}\n",
                                          TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "${value.priceFormat()} UZS",
                                              style: TextStyle(
                                                fontSize: 11.sp,
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
                                          selectedIndex = response.spot!.touchedBarGroupIndex;
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
                  )
                else
                  Expanded(
                    child: Center(
                      child: Text("noDataFound".tr()),
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
