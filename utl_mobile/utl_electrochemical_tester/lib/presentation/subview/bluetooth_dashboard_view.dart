import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bluetooth_scanner_view.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';

class BluetoothDashboardView extends BluetoothScannerView<BluetoothScannerDeviceTileController> {
  BluetoothDashboardView({
    super.key,
    required super.controller,
    required super.deviceTileBuilder,
  }) : super(
      filter: (device) => device.name.isNotEmpty,
      lockViewBuilder: () => const Scaffold(),
      scanDelay: const Duration(milliseconds: 100),
      scanButtonOnScanningColor: null,
      scanButtonOnNotScanningColor: Colors.red,
  );
}
