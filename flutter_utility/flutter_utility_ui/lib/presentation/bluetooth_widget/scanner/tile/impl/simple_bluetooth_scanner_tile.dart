import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bluetooth_scanner_tile.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';

class SimpleBluetoothScannerTile extends BluetoothScannerTile {
  const SimpleBluetoothScannerTile({
    super.key,
    required super.controller,
    this.connectedTileBackgroundColor,
    this.disconnectedTileBackgroundColor,
    this.textConnected = "Disconnect",
    this.textDisconnected = "Connect",
    this.onPressConnected,
    this.onPressDisconnected,
    this.connectedButtonStyle,
    this.disconnectedButtonStyle,
    this.contentPadding,
  });

  final Color? connectedTileBackgroundColor;
  final Color? disconnectedTileBackgroundColor;
  final String textConnected;
  final String textDisconnected;
  final void Function(BluetoothScannerDeviceTileController controller)? onPressConnected;
  final void Function(BluetoothScannerDeviceTileController controller)? onPressDisconnected;
  final ButtonStyle? connectedButtonStyle;
  final ButtonStyle? disconnectedButtonStyle;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<SimpleBluetoothScannerTile> createState() => BluetoothScannerSimpleTileState();
}

class BluetoothScannerSimpleTileState<Tile extends SimpleBluetoothScannerTile> extends BluetoothScannerTileState<Tile> {
  Color? get connectedTileBackgroundColor => widget.connectedTileBackgroundColor;
  Color? get disconnectedTileBackgroundColor => widget.disconnectedTileBackgroundColor;
  String get textConnected => widget.textConnected;
  String get textDisconnected => widget.textDisconnected;

  ButtonStyle? get connectedButtonStyle => widget.connectedButtonStyle;
  ButtonStyle? get disconnectedButtonStyle => widget.disconnectedButtonStyle;
  EdgeInsetsGeometry? get contentPadding => widget.contentPadding;

  void toggleConnection(BluetoothScannerDeviceTileController controller) {
    (controller.isConnected) ? controller.disconnect() : controller.connect();
  }
  void Function(BluetoothScannerDeviceTileController controller) get onPressConnected => widget.onPressConnected ?? toggleConnection;
  void Function(BluetoothScannerDeviceTileController controller) get onPressDisconnected => widget.onPressDisconnected ?? toggleConnection;
  VoidCallback? get onPressConnectedVoidCallback => (controller.isConnectable) ? () => onPressConnected(controller) : null;
  VoidCallback? get onPressDisconnectedVoidCallback => (controller.isConnectable) ? () => onPressDisconnected(controller) : null;

  late final StreamSubscription<void> _onConnectableStateChange;
  late final StreamSubscription<void> _onConnectionStateChange;
  late final StreamSubscription<void> _onRssiChange;

  late final ValueNotifier<bool> connectableNotifier;
  late final ValueNotifier<bool> connectionNotifier;
  late final ValueNotifier<int> rssiNotifier;
  Widget get buildConnectionButton => ValueListenableBuilder<bool>(
    valueListenable: connectableNotifier,
    builder: (context, isConnectable, child) {
      return ValueListenableBuilder<bool>(
        valueListenable: connectionNotifier,
        builder: (context, isConnected, child) {
          return ElevatedButton(
            style: isConnected
                ? connectedButtonStyle
                : disconnectedButtonStyle,
            onPressed: isConnected
                ? onPressConnectedVoidCallback
                : onPressDisconnectedVoidCallback,
            child: isConnected
                ? Text(textConnected)
                : Text(textDisconnected),
          );
        },
      );
    },
  );
  Widget get buildRssiText => ValueListenableBuilder<int>(
    valueListenable: rssiNotifier,
    builder: (context, rssi, child) {
      return Text(rssi.toString());
    },
  );
  Widget get buildTitle => (controller.name.isNotEmpty)
    ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          controller.name,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          controller.id,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    )
    : Text(controller.id);
  Widget get buildTile => ValueListenableBuilder<bool>(
    valueListenable: connectionNotifier,
    builder: (context, isConnected, child) {
      return ListTile(
        tileColor: isConnected
          ? connectedTileBackgroundColor
          : disconnectedTileBackgroundColor,
        title: buildTitle,
        leading: buildRssiText,
        trailing: buildConnectionButton,
        contentPadding: contentPadding,
      );
    },
  );

  @mustCallSuper
  @override
  void initState() {
    connectableNotifier = ValueNotifier<bool>(controller.isConnectable);
    connectionNotifier = ValueNotifier<bool>(controller.isConnected);
    rssiNotifier = ValueNotifier<int>(controller.rssi);

    _onConnectableStateChange = controller.onConnectableStateChange.listen((isConnectable) {
      connectableNotifier.value = isConnectable;
    });
    _onConnectionStateChange = controller.onConnectionStateChange.listen((isConnected) {
      connectionNotifier.value = isConnected;
    });
    _onRssiChange = controller.onRssiChange.listen((rssi) {
      rssiNotifier.value = rssi;
    });

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildTile;
  }

  @mustCallSuper
  @override
  void dispose() {
    _onConnectableStateChange.cancel();
    _onConnectionStateChange.cancel();
    _onRssiChange.cancel();
    return super.dispose();
  }

}
