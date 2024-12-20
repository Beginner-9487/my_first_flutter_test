import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/off_view/bluetooth_off_view.dart';

class ConcreteBluetoothOffView extends BluetoothOffView {
  BuildContext context;
  ConcreteBluetoothOffView({
    super.key,
    required this.context
  }) : super(
    turnOnAdapter: () {
      return FlutterBluePlus.turnOn().then((data) => true);
    }
  );
}