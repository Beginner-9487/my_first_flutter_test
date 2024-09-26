import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_r/r.dart';

class AppTheme {
  AppTheme._();

  static Color get primaryColor => (R.isLightMode) ? const Color(0xFF7EDDFF) : const Color(0xFF9A99E8);

  static TextStyle get textStyle => TextStyle(
    fontWeight: FontWeight.w600,
    color: (R.isLightMode) ? _darkText : _lightText,
    fontSize: 18,
    fontFamily: _fontName,
  );
  static Color get cursorColor => (R.isLightMode) ? _darkText : _lightText;
  static Color get backgroundCursorColor => (R.isLightMode) ? _darkText : _lightText;

  static Color get headerColor => (R.isLightMode) ? const Color(0xFFFEFEFE) : const Color(0xFF213333);

  static Color get warningColor => const Color(0xFFFB5858);
  static Color get _darkText => const Color(0xFF253840);
  static Color get _lightText => const Color(0xFF4A6572);
  static Color get _dividerColor => primaryColor;
  static Color get _dividerColor2 => backgroundCursorColor;

  static Color get bleConnectedColor => (R.isLightMode) ? const Color(0xC01085F2) : const Color(0xC032A7F3);
  static Color get bleDisconnectedColor => (R.isLightMode) ? const Color(0xC0FB4747) : const Color(0xC0FB6969);

  static const String _fontName = 'WorkSans';

  static Divider get divider => Divider(
    height: 1,
    color: _dividerColor,
  );

  static Divider get divider2 => Divider(
    height: 2,
    color: _dividerColor2,
  );

  ///通用tosat。context必须是Scaffold的子树
  static void showMsg(
      BuildContext context, {
        String? text,
        Exception? exception,
        bool? isErrorMsg,
        Duration duration = const Duration(seconds: 2, milliseconds: 500),
      }) {
    isErrorMsg ??= (exception != null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        backgroundColor: isErrorMsg ? warningColor : null,
        content: Text(
          text ??= "",
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}