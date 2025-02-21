import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:provider/provider.dart';
import 'package:utl_mobile/presentation/utl_bluetooth_scanner_view.dart';
import 'package:utl_seat_cushion/presentation/view/bluetooth/bluetooth_tile.dart';
import 'package:utl_seat_cushion/init/resources/bluetooth_resources.dart';

class BluetoothScannerView extends UtlBluetoothScannerView {
  BluetoothScannerView({
    super.key,
  }) : super(
    devices: ChangeNotifierProvider<FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier<FlutterBluePlusPersistDeviceUtil>>(
      create: (_) => BluetoothResources.bluetoothDevicesWidgetProvider.createDevicesChangeNotifier(),
      child: Consumer<FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier<FlutterBluePlusPersistDeviceUtil>>(
        builder: (context, devicesNotifier, child) {
          var devices = devicesNotifier.devices.where((device) => device.deviceName.isNotEmpty);
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              var device = devices.skip(index).first;
              return BluetoothTile(
                key: ObjectKey(device),
                device: device,
              );
            },
          );
        },
      ),
    ),
  );
}
