import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_tile/bluetooth_tile_impl.dart';

class BluetoothTileImplExecute extends BluetoothTileImpl {
  BluetoothTileImplExecute({
    super.key,
    required super.device,
    super.onPressConnected,
    super.onPressDisconnected,
    super.colorConnected,
    super.colorDisconnected,
    super.textConnected,
    super.textDisconnected,
    super.styleButtonConnected,
    super.styleButtonDisconnected,
    this.onExecute,
    this.styleButtonExecute,
    this.iconButtonExecute = const Icon(Icons.send),
    this.colorOpen,
  });

  void Function(BT_Device)? onExecute;
  ButtonStyle? styleButtonExecute;
  Icon iconButtonExecute;
  Color? colorOpen;

  @override
  State<BluetoothTileImplExecute> createState() => BluetoothTileImplExecuteState();
}

class BluetoothTileImplExecuteState<Tile extends BluetoothTileImplExecute> extends BluetoothTileImplState<Tile> {
  void Function(BT_Device)? get onExecute => (widget.onExecute != null) ? widget.onExecute! : null;

  ButtonStyle? get styleButtonExecute => widget.styleButtonExecute;
  Icon get iconButtonExecute => widget.iconButtonExecute;
  Color? get colorOpen => widget.colorOpen;

  Widget buildExecuteButton(BuildContext context) {
    return IconButton(
      style: styleButtonExecute,
      onPressed: (onExecute != null)
          ? () {
            onExecute!(device);
          }
          : null,
      icon: iconButtonExecute,
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return (isConnected)
        ? ExpansionTile(
          collapsedBackgroundColor: colorOpen,
          title: ListTile(
            title: buildTitle(context),
            trailing: buildExecuteButton(context),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: [
            ListTile(
              tileColor: colorOpen,
              leading: rssiText(),
              title: buildTitle(context),
              trailing: buildConnectionButton(context),
            ),
          ],
        )
        : super.buildTile(context);
  }
}