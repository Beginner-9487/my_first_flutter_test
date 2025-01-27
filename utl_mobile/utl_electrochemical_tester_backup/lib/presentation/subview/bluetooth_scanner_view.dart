import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';
import 'package:provider/provider.dart';
import 'package:utl_electrochemical_tester/presentation/subview/bluetooth_tile.dart';
import 'package:utl_mobile/presentation/bluetooth_scanner_view.dart';

class BluetoothScannerView extends UtlBluetoothScannerView {
  BluetoothScannerView({
    super.key,
  }) : super(
    deviceListBuilder: (context) {
      var util = context.read<FlutterBluePlusPersistDeviceWidgetUtilsProvider<FlutterBluePlusDeviceWidgetUtil>>();
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
