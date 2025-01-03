import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';

abstract class BluetoothScannerTile extends StatefulWidget {
  const BluetoothScannerTile({
    super.key,
    required this.controller,
  });

  final BluetoothScannerDeviceTileController controller;
}

abstract class BluetoothScannerTileState<Tile extends BluetoothScannerTile> extends State<Tile> with WidgetsBindingObserver {
  BluetoothScannerDeviceTileController get controller => widget.controller;
}