import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class ExecuteBluetoothScannerTile extends SimpleBluetoothScannerTile {
  const ExecuteBluetoothScannerTile({
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
    this.onPressExecute,
    this.executeButtonStyle,
    this.executeButtonIcon = const Icon(Icons.send),
    this.collapsedBackgroundColor,
  });

  final void Function(BluetoothScannerDeviceTileController controller)? onPressExecute;
  final ButtonStyle? executeButtonStyle;
  final Icon executeButtonIcon;
  final Color? collapsedBackgroundColor;

  @override
  State<ExecuteBluetoothScannerTile> createState() => BluetoothScannerExecuteTileState();
}

class BluetoothScannerExecuteTileState<Tile extends ExecuteBluetoothScannerTile> extends BluetoothScannerSimpleTileState<Tile> {
  VoidCallback? get onPressExecute => (widget.onPressExecute != null) ? () => widget.onPressExecute!(controller) : null;
  ButtonStyle? get executeButtonStyle => widget.executeButtonStyle;
  Icon get executeButtonIcon => widget.executeButtonIcon;
  Color? get collapsedBackgroundColor => widget.collapsedBackgroundColor;

  Widget get buildExecuteButton => IconButton(
    style: executeButtonStyle,
    onPressed: onPressExecute,
    icon: executeButtonIcon,
  );

  @override
  Widget get buildTile => ValueListenableBuilder<bool>(
    valueListenable: connectionNotifier,
    builder: (context, isConnected, child) {
      return (isConnected)
          ? ExpansionTile(
        collapsedBackgroundColor: collapsedBackgroundColor,
        title: ListTile(
          title: buildTitle,
          trailing: buildExecuteButton,
          contentPadding: const EdgeInsets.all(0.0),
        ),
        children: [
          ListTile(
            tileColor: collapsedBackgroundColor,
            leading: buildRssiText,
            title: buildTitle,
            trailing: buildConnectionButton,
          ),
        ],
      )
      : super.build(context);
    },
  );
}