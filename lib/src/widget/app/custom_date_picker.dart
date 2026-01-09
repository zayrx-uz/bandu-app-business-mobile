import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _DatePickerContent extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? minimumDate;
  final DateTime maximumDate;

  const _DatePickerContent({
    required this.initialDate,
    this.minimumDate,
    required this.maximumDate,
  });

  @override
  State<_DatePickerContent> createState() => _DatePickerContentState();
}

class _DatePickerContentState extends State<_DatePickerContent> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.h, color: AppColor.greyE5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Date",
                style: AppTextStyle.f600s20.copyWith(
                  fontSize: isTablet(context) ? 16.sp : 20.sp,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: AppTextStyle.f500s16.copyWith(
                    color: AppColor.grey77,
                    fontSize: isTablet(context) ? 12.sp : 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate,
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            maximumYear: widget.maximumDate.year,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.h, color: AppColor.greyE5),
            ),
          ),
          child: AppButton(
            text: "Select",
            isGradient: true,
            onTap: () {
              Navigator.pop(context, selectedDate);
            },
          ),
        ),
      ],
    );
  }
}

class CustomDatePicker {
  static Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) async {
    DateTime selectedDate = initialDate ?? DateTime.now();
    if (minimumDate != null && selectedDate.isBefore(minimumDate)) {
      selectedDate = minimumDate;
    }
    if (maximumDate != null && selectedDate.isAfter(maximumDate)) {
      selectedDate = maximumDate;
    }

    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: _DatePickerContent(
            initialDate: selectedDate,
            minimumDate: minimumDate,
            maximumDate: maximumDate ?? DateTime.now(),
          ),
        );
      },
    );
  }
}
