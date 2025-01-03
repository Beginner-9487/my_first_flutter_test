import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class ButtonsBluetoothScannerTile extends SimpleBluetoothScannerTile {
  const ButtonsBluetoothScannerTile({
    super.key,
    required super.controller,
    super.connectedTileBackgroundColor,
    super.disconnectedTileBackgroundColor,
    super.textConnected,
    super.textDisconnected,
    super.onPressConnected,
    super.onPressDisconnected,
    super.connectedButtonStyle,
    super.disconnectedButtonStyle,
    required this.buttons,
  });

  final Map<Icon, void Function(BluetoothScannerDeviceTileController controller)> buttons;

  @override
  State<ButtonsBluetoothScannerTile> createState() => BluetoothScannerButtonsTileState();
}

class BluetoothScannerButtonsTileState<Tile extends ButtonsBluetoothScannerTile> extends BluetoothScannerSimpleTileState<Tile> {
  Map<Icon, void Function(BluetoothScannerDeviceTileController controller)> get buttons => widget.buttons;

  Widget get buildButtonsRow => Row(
    children: buttons.entries.map((e) => IconButton(
      onPressed: () {
        e.value(controller);
      },
      icon: e.key,
    )).toList(),
  );

  @override
  Widget get buildTile => ValueListenableBuilder<bool>(
    valueListenable: connectionNotifier,
    builder: (context, isConnected, child) {
      return (controller.isConnected)
          ? ListView(
        children: [
          ListTile(
            leading: buildRssiText,
            title: buildTitle,
            trailing: buildConnectionButton,
          ),
          buildButtonsRow,
        ],
      )
      : super.build(context);
    },
  );
}
