import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';

import 'package:provider/provider.dart';
import 'package:utl_mobile/theme/theme.dart';

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({
    super.key,
    required this.device,
  });
  final FlutterBluePlusPersistDeviceUtil device;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier>(
          create: (_) => device.createIsConnectableChangeNotifier(),
        ),
        ChangeNotifierProvider<FlutterBluePlusPersistDeviceUtilRssiChangeNotifier>(
          create: (_) => device.createRssiChangeNotifier(),
        ),
        ChangeNotifierProvider<FlutterBluePlusDeviceIsConnectedChangeNotifier>(
          create: (_) => FlutterBluePlusDeviceIsConnectedChangeNotifier(bluetoothDevice: device.bluetoothDevice),
        ),
      ],
      child: Consumer3<
          FlutterBluePlusPersistDeviceUtilIsConnectableChangeNotifier,
          FlutterBluePlusDeviceIsConnectedChangeNotifier,
          FlutterBluePlusPersistDeviceUtilRssiChangeNotifier
      >(
        builder: (context, isConnectableNotifier, isConnectedNotifier, rssiNotifier, child) {
          bool isConnectable = isConnectableNotifier.isConnectable;
          bool isConnected = isConnectedNotifier.isConnected;
          int rssi = rssiNotifier.rssi;
          final themeData = Theme.of(context);
          final rssiText = Text(
            rssi.toString(),
          );
          final backgroundColor = (isConnected)
              ? themeData.connectedBluetoothDeviceTileColor
              : themeData.disconnectedBluetoothDeviceTileColor;
          final title = BluetoothWidgetUtil.buildTitle(
            context: context,
            deviceName: device.deviceName,
            deviceId: device.deviceId,
          );
          VoidCallback? onPressed = (isConnectable)
            ? () => FlutterBluePlusDeviceUtil.toggleConnection(device: device.bluetoothDevice)
            : null;
          final connectionIcon = (isConnected)
              ? Icon(
                Icons.bluetooth_disabled,
                color: themeData.disconnectedBluetoothDeviceTileColor,
              )
              : Icon(
                Icons.bluetooth_connected,
                color: themeData.connectedBluetoothDeviceTileColor,
              );
          final connectionButton = Container(
            decoration: BoxDecoration(
              color: themeData.textTheme.bodySmall?.color,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: connectionIcon,
              color: Colors.white,
            ),
          );
          return ListTile(
            leading: rssiText,
            title: title,
            trailing: connectionButton,
            tileColor: backgroundColor,
          );
        },
      ),
    );
  }
}
