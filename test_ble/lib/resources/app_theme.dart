import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Color get primaryColor => const Color(0xFF7EDDFF);

  static TextStyle get textStyle => TextStyle(
    fontWeight: FontWeight.w600,
    color:  _darkText,
    fontSize: 18,
    fontFamily: _fontName,
  );
  static Color get cursorColor => _darkText;
  static Color get backgroundCursorColor => _darkText;

  static Color get headerColor => const Color(0xFFFEFEFE);

  static Color get warningColor => const Color(0xFFFB5858);
  static Color get _darkText => const Color(0xFF253840);
  static Color get _dividerColor => primaryColor;

  static Color get bleConnectedColor => const Color(0xC01085F2);
  static Color get bleDisconnectedColor => const Color(0xC0FB4747);

  static const String _fontName = 'WorkSans';

  static Divider get divider => Divider(
    height: 1,
    color: _dividerColor,
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