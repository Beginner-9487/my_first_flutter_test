import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/bluetooth_widget/bluetooth_scanner_view.dart' as ui;
import 'package:flutter_utility_ui/bluetooth_widget/bluetooth_tile.dart';
import 'package:utl_mobile/utl_bluetooth_handler.dart';

class BluetoothScannerView {
  BluetoothScannerView(
      this.provider,
      this.contextResource,
      this.utl_bt_controller,
  );
  BT_Provider provider;
  ContextResource contextResource;
  UTL_BT_Controller utl_bt_controller;
  Widget build() {
    return ui.BluetoothScannerView(
        provider: provider,
        tiles: (device) => BluetoothTile(
            device: device,
            colorConnected: Colors.blue,
            colorDisconnected: Colors.red,
            textConnected: contextResource.str.disconnect,
            textDisconnected: contextResource.str.connect,
            onPressConnected: (device) {
              utl_bt_controller.disconnect(device);
            },
            onPressDisconnected: (device) {
              utl_bt_controller.connect(device);
            },
        )
    );
  }
}