import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:flutter_bluetooth_utils/fbp/flutter_blue_plus_widget_util.dart';

class ConcreteBluetoothOffView extends StatelessWidget {
  const ConcreteBluetoothOffView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BluetoothWidgetUtil.buildOffScreen(
      context: context,
      turnOn: FlutterBluePlus.turnOn,
    );
  }
}

class ConcreteBluetoothIsEnabledView extends StatelessWidget {
  ConcreteBluetoothIsEnabledView({
    super.key,
    required this.builder,
  });
  Widget Function(BuildContext context, bool isEnabled) builder;
  @override
  Widget build(BuildContext context) {
    return FlutterBluePlusWidgetUtil.buildIsEnabledWidget(
        builder: builder,
    );
  }
}
