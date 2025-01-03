import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothOffView extends StatefulWidget {
  const BluetoothOffView({
    super.key,
    required this.turnOnAdapter,
    this.bluetoothAdapterIsNotAvailable = 'Bluetooth Adapter is not available.',
    this.turnOn = 'TURN ON',
  });

  final Future<bool> Function() turnOnAdapter;
  final String bluetoothAdapterIsNotAvailable;
  final String turnOn;

  @override
  State createState() => _BluetoothOffViewState();
}

class _BluetoothOffViewState<VIEW extends BluetoothOffView> extends State<VIEW> {
  Widget get buildBluetoothOffIcon => const Icon(
    Icons.bluetooth_disabled,
    size: 200.0,
    color: Colors.white54,
  );

  Widget get buildTitle => Text(
    widget.bluetoothAdapterIsNotAvailable,
    style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
  );

  Widget get buildTurnOnButton => Padding(
    padding: const EdgeInsets.all(20.0),
    child: ElevatedButton(
      child: Text(widget.turnOn),
      onPressed: () async {
        return Permission.bluetooth.isGranted.then((isGranted) {
          if(isGranted) {
            return widget.turnOnAdapter().then((value) => null);
          } else {
            return Permission.bluetooth.request().then((permission) {
              if(permission.isGranted) {
                return widget.turnOnAdapter().then((value) => null);
              }
              return null;
            });
          }
        });
      },
    ),
  );

  Widget get buildView => ScaffoldMessenger(
    child: Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildBluetoothOffIcon,
            buildTitle,
            if (Platform.isAndroid) buildTurnOnButton,
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return buildView;
  }
}
