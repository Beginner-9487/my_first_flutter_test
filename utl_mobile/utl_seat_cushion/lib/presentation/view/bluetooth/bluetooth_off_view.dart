import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_utils/bluetooth_widget_util.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';

class BluetoothOffView extends StatelessWidget {
  const BluetoothOffView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BluetoothWidgetUtil.buildOffScreen(
      context: context,
      turnOn: BluetoothResources.turnOnBluetooth,
    );
  }
}
