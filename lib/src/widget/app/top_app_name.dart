import 'package:bandu_business/src/theme/const_style.dart';
import 'package:flutter/material.dart';

class TopAppName extends StatelessWidget {
  final double? fontSize;
  final Color? color;

  const TopAppName({super.key, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Bandu",
      style: AppTextStyle.f800s32.copyWith(
        fontFamily: "Fontspring-DEMO",
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
