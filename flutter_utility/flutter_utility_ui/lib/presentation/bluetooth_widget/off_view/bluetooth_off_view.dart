import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class _BluetoothOffViewState<VIEW extends BluetoothOffView> extends State<VIEW> with WidgetsBindingObserver {
  Locale? _currentLocale;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Colors.white54,
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      widget.bluetoothAdapterIsNotAvailable,
      style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: Text(widget.turnOn),
        onPressed: () async {
          widget.turnOnAdapter();
          return;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentLocale = View.of(context).platformDispatcher.locale;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (locales != null && locales.isNotEmpty) {
      final newLocale = locales.first;
      if (_currentLocale != newLocale) {
        setState(() {
          _currentLocale = newLocale;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildBluetoothOffIcon(context),
              buildTitle(context),
              if (Platform.isAndroid) buildTurnOnButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
