import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';
import 'package:provider/provider.dart';
import 'package:utl_amulet/init/resources/infrastructure/bluetooth_resource.dart';
import 'package:utl_amulet/presentation/view/bluetooth/bluetooth_tile.dart';
import 'package:utl_mobile/presentation/utl_bluetooth_scanner_view.dart';

class BluetoothScannerView extends UtlBluetoothScannerView {
  BluetoothScannerView({
    super.key,
  }) : super(
    devices: ChangeNotifierProvider<FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier<FlutterBluePlusPersistDeviceUtil>>(
      create: (_) => BluetoothResource.bluetoothDevicesWidgetProvider.createDevicesChangeNotifier(),
      child: Consumer<FlutterBluePlusPersistBluetoothDevicesToDevicesChangeNotifier<FlutterBluePlusPersistDeviceUtil>>(
        builder: (context, devicesNotifier, child) {
          final devices = devicesNotifier.devices.where((device) => device.deviceName.isNotEmpty);
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices.skip(index).first;
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
