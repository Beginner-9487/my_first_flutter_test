import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class BluetoothTile extends SimpleBluetoothScannerTile {
  const BluetoothTile({
    super.key,
    required super.controller,
    super.connectedTileBackgroundColor = Colors.blue,
    super.disconnectedTileBackgroundColor = Colors.red,
    super.textConnected = "",
    super.textDisconnected = "",
  });
  @override
  State<BluetoothTile> createState() => _State();
}

class _State extends BluetoothScannerSimpleTileState<BluetoothTile> with WidgetsBindingObserver {
  @override
  String get textConnected => context.appLocalizations!.disconnect;
  @override
  String get textDisconnected => context.appLocalizations!.connect;
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @mustCallSuper
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    setState(() {});
  }
  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
