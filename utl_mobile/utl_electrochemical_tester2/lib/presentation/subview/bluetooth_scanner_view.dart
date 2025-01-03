import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bluetooth_scanner_view.dart' as ui;

class BluetoothScannerView<Device> extends ui.BluetoothScannerView<Device> {
  BluetoothScannerView({
    super.key,
    required super.controller,
    required super.deviceTileBuilder,
  }) : super(
    // filter: (device) => device.name.isNotEmpty,
    filter: (device) => true,
    scanButtonOnScanningColor: Colors.red,
    scanButtonOnNotScanningColor: null,
  );
}
