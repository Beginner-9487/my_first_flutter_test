import 'dart:async';

import 'package:flutter/material.dart';

class BluetoothWidgetUtil {
  const BluetoothWidgetUtil._();
  static Widget buildScanButton({
    required bool isScanning,
    required VoidCallback? toggleScan,
    Color? scanButtonOnScanningColor = Colors.red,
    Color? scanButtonOnNotScanningColor,
    Icon scanButtonOnScanningIcon = const Icon(Icons.stop),
    Icon scanButtonOnNotScanningIcon = const Icon(Icons.bluetooth_searching),
  }) {
    return FloatingActionButton(
      onPressed: toggleScan,
      backgroundColor: (isScanning)
          ? scanButtonOnScanningColor
          : scanButtonOnNotScanningColor,
      child: (isScanning)
          ? scanButtonOnScanningIcon
          : scanButtonOnNotScanningIcon,
    );
  }
  static Widget buildScanner({
    required Future<void> Function() rescan,
    required Widget devices,
    Widget? scanButton,
  }) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: rescan,
        child: devices,
      ),
      floatingActionButton: scanButton,
    );
  }
  static Widget buildOffScreen({
    required BuildContext context,
    required VoidCallback turnOn,
    String message = 'Bluetooth Adapter is not available.',
    String buttonText = 'TURN ON',
  }) {
    const Widget icon = Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Colors.white54,
    );
    final Widget title = Builder(
      builder: (context) {
        return Text(
          message,
          style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
        );
      },
    );
    final Widget turnOnButton = Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: turnOn,
        child: Text(buttonText),
      ),
    );
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              title,
              turnOnButton,
            ],
          ),
        ),
      ),
    );
  }
  static Widget buildTitle({
    required BuildContext context,
    required String deviceName,
    required String deviceId,
  }) {
    return (deviceName.isNotEmpty)
      ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              deviceName,
              overflow: TextOverflow.ellipsis,
            ),
            Builder(
              builder: (context) {
                return Text(
                  deviceId,
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ],
        )
      : Text(deviceId);
  }
}
