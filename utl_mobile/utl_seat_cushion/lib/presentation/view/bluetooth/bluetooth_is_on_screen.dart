import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utl_mobile/utl_bluetooth/utl_bluetooth_resources.dart';

class BluetoothIsOnView extends ChangeNotifierProvider<UtlBluetoothIsOnChangeNotifier> {
  BluetoothIsOnView({
    super.key,
    required Widget Function(BuildContext context, bool isOn) builder,
  }) : super(
    create: (_) => UtlBluetoothIsOnChangeNotifier(),
    child: Consumer<UtlBluetoothIsOnChangeNotifier>(
      builder: (context, isOnNotifier, child) {
        bool isOn = isOnNotifier.isOn;
        return builder(context, isOn);
      },
    ),
  );
}
