import 'package:flutter/material.dart';

class DeviceHelper {
  static bool isTablet(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return shortestSide >= 600;
  }
}