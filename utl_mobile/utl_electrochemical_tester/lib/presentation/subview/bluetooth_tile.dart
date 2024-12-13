import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class BluetoothTile extends SimpleBluetoothScannerTile<BluetoothScannerDeviceTileController> {
  BluetoothTile({
    super.key,
    required BuildContext buildContext,
    required super.device,
    super.onPressConnected,
    super.onPressDisconnected,
  }) : super(
    connectedTileBackgroundColor: Colors.blue,
    disconnectedTileBackgroundColor: Colors.red,
    textConnected: buildContext.appLocalizations!.disconnect,
    textDisconnected: buildContext.appLocalizations!.connect,
  );
}
