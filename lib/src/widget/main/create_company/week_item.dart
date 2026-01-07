import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WeekItem extends StatefulWidget {
  const WeekItem({
    super.key,
    required this.onChange,
    this.initialData,
  });
  final ValueChanged<Map<String, dynamic>> onChange;
  final Map<String, dynamic>? initialData;

  @override
  State<WeekItem> createState() => _WeekItemState();
}

class _WeekItemState extends State<WeekItem> {
  bool isWorkingDaysEnabled = false;
  List<bool> expandedStates = List.generate(7, (index) => false);
  late Map<String, Map<String, dynamic>> schedule;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null && widget.initialData!.isNotEmpty) {
      schedule = Map<String, Map<String, dynamic>>.from(
        widget.initialData!.map(
          (key, value) => MapEntry(
            key,
            Map<String, dynamic>.from(value as Map),
          ),
        ),
      );
    } else {
      schedule = {
        for (var day in dayEn)
          day: {
            "open": null,
            "close": null,
            "closed": true,
          }
      };
    }
  }

  bool _isValidTimeRange(String open, String close) {
    DateTime openTime = DateFormat("HH:mm").parse(open);
    DateTime closeTime = DateFormat("HH:mm").parse(close);
    return closeTime.isAfter(openTime);
  }

  void _showTimePicker(int index, bool isOpenTime) {
    String dayKey = dayEn[index];
    DateTime initialDateTime = DateTime.now();

    if (schedule[dayKey]![isOpenTime ? "open" : "close"] != null) {
      try {
        initialDateTime = DateFormat("HH:mm").parse(schedule[dayKey]![isOpenTime ? "open" : "close"]);
      } catch (_) {}
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r),
          ),
        ),
        height: 320.h,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: initialDateTime,
                onDateTimeChanged: (DateTime newTime) => initialDateTime = newTime,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppButton(
                onTap: () {
                  String formattedTime = DateFormat('HH:mm').format(initialDateTime);

                  setState(() {
                    String? currentOpen = isOpenTime ? formattedTime : schedule[dayKey]!["open"];
                    String? currentClose = isOpenTime ? schedule[dayKey]!["close"] : formattedTime;

                    if (currentOpen != null && currentClose != null) {
                      if (_isValidTimeRange(currentOpen, currentClose)) {
                        schedule[dayKey]!["open"] = currentOpen;
                        schedule[dayKey]!["close"] = currentClose;
                        schedule[dayKey]!["closed"] = false;
                        widget.onChange(Map<String, dynamic>.from(schedule));
                        Navigator.pop(context);
                      } else {
                        AppService.errorToast(context, "Closing time must be after opening time!");
                      }
                    } else {
                      if (isOpenTime) {
                        schedule[dayKey]!["open"] = formattedTime;
                      } else {
                        schedule[dayKey]!["close"] = formattedTime;
                      }
                      Navigator.pop(context);
                    }
                  });
                },
                text: "Save",
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(width: 1.w, color: Colors.grey.withValues(alpha: 0.4)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Working days", style: AppTextStyle.f500s16.copyWith(
                fontSize:  isTablet(context) ? 12.sp : 16.sp
              )),
              CupertinoSwitch(
                value: isWorkingDaysEnabled,
                onChanged: (v) => setState(() => isWorkingDaysEnabled = v),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: SizedBox(
              width: double.infinity,
              height: isWorkingDaysEnabled ? null : 0,
              child: Column(
                children: [
                  SizedBox(height: 15.h),
                  ...List.generate(days.length, (index) {
                    String displayDay = days[index];
                    String dataKey = dayEn[index];
                    bool isExpanded = expandedStates[index];
                    bool isCompleted = schedule[dataKey]!["closed"] == false;

                    return Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => setState(() => expandedStates[index] = !isExpanded),
                            child: Row(
                              children: [
                                Text(displayDay, style: AppTextStyle.f600s16.copyWith(
                                  fontSize: isTablet(context) ? 12.sp : 16.sp
                                )),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 200),
                                  turns: isExpanded ? 0.5 : 0,
                                  child: Icon(Icons.arrow_drop_down, color: Colors.black, size: isTablet(context) ? 18.sp : 25.sp),
                                ),
                                const Spacer(),
                                if (isCompleted)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      "${schedule[dataKey]!["open"]} - ${schedule[dataKey]!["close"]}",
                                      style: TextStyle(fontSize: 12.sp, color: Colors.green, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              width: double.infinity,
                              height: isExpanded ? null : 0,
                              child: Column(
                                children: [
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _showTimePicker(index, true),
                                          child: Container(
                                            padding: EdgeInsets.all(10.w),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(7.r),
                                            ),
                                            child: Text(
                                              schedule[dataKey]!["open"] ?? "Opening time",
                                              style: TextStyle(
                                                color: schedule[dataKey]!["open"] == null ? Colors.grey : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: isTablet(context) ? 10.sp : 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _showTimePicker(index, false),
                                          child: Container(
                                            padding: EdgeInsets.all(10.w),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(7.r),
                                            ),
                                            child: Text(
                                              schedule[dataKey]!["close"] ?? "Closing time",
                                              style: TextStyle(
                                                color: schedule[dataKey]!["close"] == null ? Colors.grey : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: isTablet(context) ? 10.sp : 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
List<String> dayEn = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];