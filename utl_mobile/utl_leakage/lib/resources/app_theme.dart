import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_r/r.dart';

class AppTheme {
  AppTheme._();

  static Color get primaryColor => (R.isLightMode) ? const Color(0xFF7EDDFF) : const Color(0xFF9A99E8);

  static Color get _dividerColor => primaryColor;

  static Color get bleConnectedColor => (R.isLightMode) ? const Color(0xC01085F2) : const Color(0xC032A7F3);
  static Color get bleDisconnectedColor => (R.isLightMode) ? const Color(0xC0FB4747) : const Color(0xC0FB6969);

  static const String _fontName = 'WorkSans';

  static const double heightDivider = 1;
  static Divider get divider => Divider(
    height: heightDivider,
    color: _dividerColor,
  );
}