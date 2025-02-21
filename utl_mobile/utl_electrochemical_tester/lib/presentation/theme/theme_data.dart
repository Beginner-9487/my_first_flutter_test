import 'package:flutter/material.dart';

extension AppThemeData on ThemeData {
  Divider get divider => const Divider();
  Color get lineChartModeEnabledColor => brightness == Brightness.light
      ? Colors.green
      : Colors.green[700]!;
  Color get lineChartTypeEnabledColor => brightness == Brightness.light
      ? Colors.blue
      : Colors.blue[700]!;
  Color get downloadEnabledColor => brightness == Brightness.light
      ? Colors.orange
      : Colors.orange[700]!;
  Color get clearEnabledColor => brightness == Brightness.light
      ? Colors.red
      : Colors.red[700]!;
}
