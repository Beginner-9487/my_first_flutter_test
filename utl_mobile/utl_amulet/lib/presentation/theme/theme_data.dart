import 'package:flutter/material.dart';

extension AppThemeData on ThemeData {
  Color get savingEnabledColor => brightness == Brightness.light
      ? Colors.green
      : Colors.green[700]!;
  Color get downloadEnabledColor => brightness == Brightness.light
      ? Colors.orange
      : Colors.orange[700]!;
  Color get clearEnabledColor => brightness == Brightness.light
      ? Colors.red
      : Colors.red[700]!;
}
