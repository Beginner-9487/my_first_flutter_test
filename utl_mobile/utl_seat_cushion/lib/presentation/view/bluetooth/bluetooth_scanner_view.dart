import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';
import 'package:provider/provider.dart';
import 'package:utl_mobile/presentation/bluetooth_scanner_view.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth/bluetooth_tile.dart';

class BluetoothScannerView extends UtlBluetoothScannerView {
  BluetoothScannerView({
    super.key,
  }) : super(
      deviceListBuilder: (context) {
        var util = context.read<FlutterBluePlusPersistDeviceWidgetsUtil<FlutterBluePlusDeviceWidgetUtil>>();
        return util.buildDevicesList(
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
