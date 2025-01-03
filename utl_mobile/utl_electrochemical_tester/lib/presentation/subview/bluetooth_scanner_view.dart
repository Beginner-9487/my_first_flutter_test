import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bluetooth_scanner_view.dart' as ui;
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';

class BluetoothScannerView extends ui.BluetoothScannerView<BluetoothScannerDeviceTileController> {
  BluetoothScannerView({
    super.key,
    required super.controller,
    required super.deviceTileBuilder,
  }) : super(
    filter: (device) => device.name.isNotEmpty,
    scanButtonOnScanningColor: Colors.red,
    scanButtonOnNotScanningColor: null,
  );
}
