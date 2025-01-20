import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_widget_util.dart';
import 'package:utl_mobile/theme/theme.dart';

class UtlBluetoothScannerView extends StatelessWidget {
  final Widget Function(BuildContext) deviceListBuilder;
  final Duration scanDuration;
  const UtlBluetoothScannerView({
    super.key,
    required this.deviceListBuilder,
    this.scanDuration = const Duration(seconds: 15),
  });
  @override
  Widget build(BuildContext context) {
    var scanButton = FlutterBluePlusWidgetUtil.buildScanningWidget(
      builder: (context, isScanning) {
        var themeData = Theme.of(context);
        return BluetoothWidgetUtil.buildScanButton(
          isScanning: isScanning,
          toggleScan: () => FlutterBluePlusWidgetUtil.toggleScan(
            isScanning: isScanning,
            scanDuration: scanDuration,
          ),
          scanButtonOnScanningColor: themeData.stopScanningBluetoothButtonColor,
        );
      },
    );
    return BluetoothWidgetUtil.buildScanner(
      rescan: () => FlutterBluePlusWidgetUtil.rescan(
        scanDuration: scanDuration,
      ),
      devicesWidget: deviceListBuilder(context),
      scanButton: scanButton,
    );
  }
}
