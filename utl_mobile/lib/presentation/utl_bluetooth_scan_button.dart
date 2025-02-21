import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_util.dart';
import 'package:flutter_bluetooth_utils/permission_handler_util/permission_handler_bluetooth_util.dart';
import 'package:provider/provider.dart';
import 'package:utl_mobile/theme/theme.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';

class UtlBluetoothScanButton extends ChangeNotifierProvider<UtlBluetoothIsScanningChangeNotifier> {
  UtlBluetoothScanButton({
    super.key,
  }) : super(
    create: (_) => UtlBluetoothIsScanningChangeNotifier(),
    child: Consumer<UtlBluetoothIsScanningChangeNotifier>(
      builder: (context, isScanningNotifier, child) {
        var isScanning = isScanningNotifier.isScanning;
        var themeData = Theme.of(context);
        return BluetoothWidgetUtil.buildScanButton(
          isScanning: isScanning,
          toggleScan: () => FlutterBluePlusUtil.toggleScan(
            requestPermission: PermissionHandlerBluetoothUtil.requestPermission,
            isScanning: isScanning,
            scanDuration: UtlBluetoothResources.scanDuration,
          ),
          scanButtonOnScanningColor: themeData.stopScanningBluetoothButtonColor,
        );
      }
    )
  );
}
