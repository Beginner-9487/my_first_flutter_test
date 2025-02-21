import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_persist_devices_util.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          var rssiText = Text(rssi.toString());
          var themeData = Theme.of(context);
          var backgroundColor = (isConnected)
              ? themeData.connectedBluetoothDeviceTileColor
              : themeData.disconnectedBluetoothDeviceTileColor;
          var title = BluetoothWidgetUtil.buildTitle(
            context: context,
            deviceName: device.deviceName,
            deviceId: device.deviceId,
          );
          VoidCallback? onPressed = (isConnectable)
              ? () => FlutterBluePlusDeviceUtil.toggleConnection(device: device.bluetoothDevice)
              : null;
          var connectionButton = ElevatedButton(
            onPressed: onPressed,
            child: Builder(
              builder: (context) {
                var appLocalizations = AppLocalizations.of(context)!;
                return Text(device.bluetoothDevice.isConnected
                    ? appLocalizations.disconnectBluetoothButtonText
                    : appLocalizations.connectBluetoothButtonText
                );
              },
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
