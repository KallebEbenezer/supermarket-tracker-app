import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class AppGrid {
  static const columns = 4;
  static const gutter = AppSpacing.md;
  static const pagePadding = EdgeInsets.symmetric(horizontal: AppSpacing.md);
  static const maxContentWidth = 1200.0;

  static double columnWidth(double availableWidth) =>
      (availableWidth - (gutter * (columns - 1))) / columns;
}

abstract final class AppRadii {
  static const small = BorderRadius.all(Radius.circular(8));
  static const medium = BorderRadius.all(Radius.circular(12));
  static const large = BorderRadius.all(Radius.circular(16));
  static const pill = BorderRadius.all(Radius.circular(999));
}
