import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:utl_mobile/presentation/utl_bluetooth_scan_button.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';

class UtlBluetoothScannerView extends StatelessWidget {
  final Widget devices;
  const UtlBluetoothScannerView({
    super.key,
    required this.devices,
  });
  @override
  Widget build(BuildContext context) {
    var scanButton = UtlBluetoothScanButton();
    return BluetoothWidgetUtil.buildScanner(
      rescan: UtlBluetoothResources.rescan,
      devices: devices,
      scanButton: scanButton,
    );
  }
}
