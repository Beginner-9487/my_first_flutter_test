import 'package:flutter/material.dart';

extension UtlTheme on ThemeData {
  Color get screenBackgroundColor => brightness == Brightness.light
      ? Colors.white
      : Colors.black;
  Color get bluetoothColor => brightness == Brightness.light
      ? Colors.blue
      : Colors.indigoAccent;
  Color get connectedBluetoothDeviceTileColor => bluetoothColor;
  Color get disconnectedBluetoothDeviceTileColor => brightness == Brightness.light
      ? Colors.red
      : Colors.red[900]!;
  Color get stopScanningBluetoothButtonColor => disconnectedBluetoothDeviceTileColor;
}
