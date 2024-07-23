import 'package:flutter/material.dart';

///通用toast。context必须是Scaffold的子树
void showMsg(
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
      backgroundColor: isErrorMsg ? _warningColor : null,
      content: Text(
        text ??= "",
        style: const TextStyle(color: Colors.white),
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Color get _warningColor => const Color(0xFFFB5858);