import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerBluetoothUtil {
  const PermissionHandlerBluetoothUtil._();
  static Future<bool> requestPermission() async {
    if(!(await Permission.bluetooth.isGranted)) {
      if(!(await Permission.bluetooth.request().isGranted)) {
        return false;
      }
    }
    if(!(await Permission.location.isGranted)) {
      if(!(await Permission.location.request().isGranted)) {
        return false;
      }
    }
    return true;
  }
}
