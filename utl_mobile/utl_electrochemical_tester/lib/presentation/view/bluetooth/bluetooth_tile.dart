import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_device_widget_util.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_mobile/theme/theme.dart';

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({
    super.key,
    required this.device,
  });
  final FlutterBluePlusDeviceWidgetUtil device;
  @override
  Widget build(BuildContext context) {
    return device.buildConnectionWidget(
      builder: (context, isConnectable, isConnected) {
        var rssi = device.buildRssiText();
        var title = BluetoothWidgetUtil.buildTitle(
          context: context,
          deviceName: device.deviceName,
          deviceId: device.deviceId,
        );
        var connectionButton = ElevatedButton(
          onPressed: (isConnectable)
              ? device.toggleConnection
              : null,
          child: Builder(
              builder: (context) {
                var appLocalizations = AppLocalizations.of(context)!;
                return Text(device.bluetoothDevice.isConnected
                  ? appLocalizations.disconnectBluetoothButtonText
                  : appLocalizations.connectBluetoothButtonText
                );
              }
          ),
        );
        var themeData = Theme.of(context);
        var backgroundColor = (isConnected)
            ? themeData.connectedBluetoothDeviceTileColor
            : themeData.disconnectedBluetoothDeviceTileColor;
        return ListTile(
          leading: rssi,
          title: title,
          trailing: connectionButton,
          tileColor: backgroundColor,
        );
      },
    );
  }
}
