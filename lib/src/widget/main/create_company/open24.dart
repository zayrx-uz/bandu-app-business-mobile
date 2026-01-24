import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Open24Item extends StatefulWidget {
  const Open24Item({
    super.key,
    required this.onChange,
    this.value = false,
    this.onTap,
  });
  final ValueChanged<bool> onChange;
  final bool value;
  final VoidCallback? onTap;

  @override
  State<Open24Item> createState() => _Open24ItemState();
}

class _Open24ItemState extends State<Open24Item> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(Open24Item oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap?.call();
        value = !value;
        setState(() {});
        widget.onChange.call(value);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: 1.w,
            color : Colors.grey.withValues(alpha: 0.4)
          )
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal : 6.w , vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "open247".tr(),
              style: AppTextStyle.f500s16.copyWith(
                fontSize: isTablet(context) ? 12.sp : 16.sp
              )
            ),
            CupertinoSwitch(
              value: value,
              onChanged: (v) {
                widget.onTap?.call();
                value = v;
                setState(() {});
                widget.onChange.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
