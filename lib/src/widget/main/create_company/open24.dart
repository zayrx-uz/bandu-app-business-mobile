import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Open24Item extends StatefulWidget {
  const Open24Item({super.key, required this.onChange});
  final ValueChanged<bool> onChange;

  @override
  State<Open24Item> createState() => _Open24ItemState();
}

class _Open24ItemState extends State<Open24Item> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
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
            color : Colors.grey.withOpacity(0.4)
          )
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal : 6.w , vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "24/7 faoliyat yuritadimi",
              style: AppTextStyle.f500s16
            ),
            CupertinoSwitch(
              value: value,
              onChanged: (v) {
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
