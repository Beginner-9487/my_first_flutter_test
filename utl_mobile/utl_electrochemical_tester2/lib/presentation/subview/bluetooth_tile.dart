import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';
import 'package:flutter_utility_ui/presentation/language_observer_view.dart';

class BluetoothTile extends LanguageObserverView {
  BluetoothTile({
    super.key,
    required BluetoothScannerDeviceTileController controller,
  }) : super(
      builder: (context, locales) {
        return SimpleBluetoothScannerTile(
          key: UniqueKey(),
          controller: controller,
          connectedTileBackgroundColor: Colors.blue,
          disconnectedTileBackgroundColor: Colors.red,
          textConnected: context.appLocalizations!.disconnect,
          textDisconnected: context.appLocalizations!.connect,
        );
      }
  );
}