import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_revenue_series_model.dart' show DashboardRevenueSeriesData, SeriesItem;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  int selectedIndex = 0;
  DashboardRevenueSeriesData? data;
  List<double> amounts = [];
  List<SeriesItem> seriesOrdered = [];
  final ScrollController _scrollController = ScrollController();

  static const double _maxY = 5_000_000;
  static const double _interval = 500_000;
  final double _itemWidth = 54.w;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void _scrollToCurrentMonth() {
    if (seriesOrdered.isEmpty) return;

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    // Try to find current month by parsing the key (format: "YYYY-MM" or similar)
    int currentIndex = -1;
    for (int i = 0; i < seriesOrdered.length; i++) {
      final item = seriesOrdered[i];
      // Try to parse key as date (format: "YYYY-MM" or "YYYY-MM-DD")
      final parts = item.key.split('-');
      if (parts.length >= 2) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        if (year != null && month != null && year == currentYear && month == currentMonth) {
          currentIndex = i;
          break;
        }
      }
    }

    // If still not found, try matching by label as fallback
    if (currentIndex == -1) {
      final currentMonthName = DateFormat('MMM').format(now);
      currentIndex = seriesOrdered.indexWhere(
        (item) => item.label.toLowerCase().contains(currentMonthName.toLowerCase())
      );
    }

    // If still not found, select the last item (most recent month)
    if (currentIndex == -1) {
      currentIndex = seriesOrdered.length - 1;
    }

    // Scroll to center the current month
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter(currentIndex);
    });
  }

  void _scrollToCenter(int targetIndex) {
    if (!mounted) return;
    
    // Ensure targetIndex is valid
    if (targetIndex < 0 || targetIndex >= seriesOrdered.length) {
      return;
    }

    // Set selected index first
    setState(() {
      selectedIndex = targetIndex;
    });

    // Try to scroll immediately, if controller is ready
    if (_scrollController.hasClients) {
      _performScroll(targetIndex);
    } else {
      // Wait for controller to be ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _scrollController.hasClients) {
          _performScroll(targetIndex);
        } else if (mounted) {
          // Try one more time
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted && _scrollController.hasClients) {
              _performScroll(targetIndex);
            }
          });
        }
      });
    }
  }

  void _performScroll(int targetIndex) {
    if (!_scrollController.hasClients || !mounted) return;
    if (targetIndex < 0 || targetIndex >= seriesOrdered.length) return;

    // Get the visible width of the scroll view
    final visibleWidth = _scrollController.position.viewportDimension;
    
    // Calculate the position of the target month (center of the month bar)
    final targetMonthCenter = targetIndex * _itemWidth + (_itemWidth / 2);
    
    // Calculate scroll offset to center the target month
    // We want the target month's center to be at the center of the visible area
    final scrollOffset = targetMonthCenter - (visibleWidth / 2);
    
    // Clamp to valid range
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = scrollOffset.clamp(0.0, maxScroll);

    // Use jumpTo for immediate positioning
    _scrollController.jumpTo(clampedOffset);
    
    // Verify the position after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients && mounted) {
        final currentOffset = _scrollController.offset;
        final difference = (currentOffset - clampedOffset).abs();
        // If there's a significant difference, adjust
        if (difference > 5) {
          _scrollController.jumpTo(clampedOffset);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetRevenueSeriesSuccessState) {
            data = state.data;
            amounts = [];
            seriesOrdered = [];

            if (data!.series.isNotEmpty) {
              // Sort series by date to ensure chronological order (oldest to newest)
              seriesOrdered = List<SeriesItem>.from(data!.series);
              seriesOrdered.sort((a, b) {
                // Parse keys as dates (format: "YYYY-MM" or "YYYY-MM-DD")
                final aParts = a.key.split('-');
                final bParts = b.key.split('-');
                if (aParts.length >= 2 && bParts.length >= 2) {
                  final aYear = int.tryParse(aParts[0]) ?? 0;
                  final aMonth = int.tryParse(aParts[1]) ?? 0;
                  final bYear = int.tryParse(bParts[0]) ?? 0;
                  final bMonth = int.tryParse(bParts[1]) ?? 0;
                  if (aYear != bYear) {
                    return aYear.compareTo(bYear);
                  }
                  return aMonth.compareTo(bMonth);
                }
                return 0;
              });
              for (var item in seriesOrdered) {
                amounts.add(item.amount);
              }
              // Ensure selectedIndex is within bounds
              if (selectedIndex >= seriesOrdered.length) {
                selectedIndex = seriesOrdered.length - 1;
              }
              if (selectedIndex < 0 && seriesOrdered.isNotEmpty) {
                selectedIndex = 0;
              }
              _scrollToCurrentMonth();
            } else {
              selectedIndex = 0;
            }
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarWidget(
                isAppName: false,
                text: "cashFlow".tr(),
                isBack: true,
              ),
              if (state is GetRevenueSeriesLoadingState && data == null)
                Expanded(
                  child: const Center(
                    child: CupertinoActivityIndicator(color: AppColor.black),
                  ),
                )
              else if (data == null)
                Expanded(
                  child: Center(child: Text("noDataFound".tr())),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
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
                                      data!.total.changePercent > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: data!.total.changePercent > 0 ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "${data!.total.changePercent.toStringAsFixed(1)}%",
                                      style: TextStyle(
                                        color: data!.total.changePercent > 0 ? Colors.green : Colors.red,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                ),
                              Text(
                                "${"lastUpdated".tr()}: ${data!.lastUpdatedAt != null ? DateTime.tryParse(data!.lastUpdatedAt!)?.toDDMMYYY() ?? DateTime.now().toDDMMYYY() : DateTime.now().toDDMMYYY()}",
                                style: AppTextStyle.f400s14.copyWith(color: AppColor.grey58),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        if (amounts.isNotEmpty)
                          Container(
                            height: 502.h,
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(11, (i) {
                                    final value = 5.0 - (i * 0.5);
                                    String label;
                                    if (value == 0) {
                                      label = "0";
                                    } else if (value < 1) {
                                      label = "${(value * 1000).toInt()}k";
                                    } else if (value == value.toInt()) {
                                      label = "${value.toInt()} ${"mln".tr()}";
                                    } else {
                                      label = "${value.toStringAsFixed(1)} ${"mln".tr()}";
                                    }
                                    return SizedBox(
                                      height: (280.h - 40.h) / 10,
                                      child: Center(
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: 12.sp, color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: SizedBox(
                                      width: amounts.length * _itemWidth,
                                      child: BarChart(
                                        BarChartData(
                                          minY: 0,
                                          maxY: _maxY,
                                          borderData: FlBorderData(show: false),
                                          gridData: FlGridData(
                                            drawVerticalLine: false,
                                            horizontalInterval: _interval,
                                            getDrawingHorizontalLine: (value) => FlLine(
                                              color: Colors.grey.shade300,
                                              strokeWidth: 1,
                                            ),
                                          ),
                                          barGroups: List.generate(amounts.length, (i) {
                                            final isSelected = selectedIndex >= 0 && selectedIndex < amounts.length && selectedIndex == i;
                                            return BarChartGroupData(
                                              x: i,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: (i < amounts.length ? amounts[i] : 0.0).clamp(0.0, _maxY),
                                                  width: 42.w,
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: isSelected ? AppColor.yellowFFC : AppColor.greyE5,
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
                                                reservedSize: 28.h,
                                                getTitlesWidget: (v, meta) {
                                                  int index = v.toInt();
                                                  if (index >= 0 && index < seriesOrdered.length && index < amounts.length) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(top: 8.h),
                                                      child: Text(
                                                        seriesOrdered[index].label,
                                                        style: AppTextStyle.f400s14.copyWith(
                                                          color: (selectedIndex >= 0 && selectedIndex < seriesOrdered.length && selectedIndex == index) ? AppColor.black : AppColor.grey77,
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
                                              if (response != null && response.spot != null && event.isInterestedForInteractions) {
                                                final newIndex = response.spot!.touchedBarGroupIndex;
                                                if (newIndex >= 0 && newIndex < amounts.length && newIndex < seriesOrdered.length) {
                                                  setState(() {
                                                    selectedIndex = newIndex;
                                                  });
                                                }
                                              }
                                            },
                                            touchTooltipData: BarTouchTooltipData(
                                              getTooltipColor: (group) => AppColor.yellowFFC,
                                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                if (groupIndex >= 0 && groupIndex < amounts.length) {
                                                  return BarTooltipItem(
                                                    "${"revenue".tr()}\n${amounts[groupIndex].toInt().priceFormat()} UZS",
                                                    TextStyle(fontSize: 11.sp, color: AppColor.white),
                                                  );
                                                }
                                                return BarTooltipItem(
                                                  "${"revenue".tr()}\n0 UZS",
                                                  TextStyle(fontSize: 11.sp, color: AppColor.white),
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
                          )
                        else
                          SizedBox(
                            height: 502.h,
                            child: Center(child: Text("noDataFound".tr())),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
