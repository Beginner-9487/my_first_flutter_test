import 'package:flutter/material.dart';
import 'package:utl_mobile/presentation/bluetooth_scanner_view.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth/bluetooth_tile.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';

class BluetoothScannerView extends UtlBluetoothScannerView {
  BluetoothScannerView({
    super.key,
  }) : super(
    deviceListBuilder: (context) {
      return BluetoothResources.bluetoothWidgetsProvider.buildDevicesList(
        builder: (context, device) {
          return BluetoothTile(
            key: ObjectKey(device),
            device: device,
          );
        },
        filter: (device) => device.deviceName.isNotEmpty,
      );
    }
  );
}
