import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const level1 = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 4, offset: Offset(0, 2)),
  ];
  static const level2 = [
    BoxShadow(color: Color(0x29000000), blurRadius: 10, offset: Offset(0, 4)),
  ];
  static const level3 = [
    BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 8)),
  ];
}

abstract final class AppElevation {
  static const none = 0.0;
  static const low = 1.0;
  static const medium = 3.0;
  static const high = 6.0;
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
  static const standardCurve = Curves.easeOutCubic;
}
