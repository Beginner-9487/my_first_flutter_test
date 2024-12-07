import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_tile/bluetooth_tile_impl.dart';

class BluetoothTileImplExecuteText extends BluetoothTileImpl {
  BluetoothTileImplExecuteText({
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
    this.iconButtonExecute = const Icon(Icons.play_arrow),
    this.colorOpen,
    this.onTextChange,
    this.textDefault = "",
  });

  void Function(BT_Device, String)? onExecute;
  ButtonStyle? styleButtonExecute;
  Icon iconButtonExecute;
  Color? colorOpen;

  void Function(BT_Device, String)? onTextChange;
  String textDefault;

  @override
  State<BluetoothTileImplExecuteText> createState() => BluetoothTileImplExecuteTextState();
}

class BluetoothTileImplExecuteTextState<Tile extends BluetoothTileImplExecuteText> extends BluetoothTileImplState<Tile> {
  late TextEditingController _labelNameController;

  ButtonStyle? get styleButtonExecute => widget.styleButtonExecute;
  Icon get iconButtonExecute => widget.iconButtonExecute;
  Color? get colorOpen => widget.colorOpen;

  void Function(BT_Device, String) get onTextChange => (widget.onTextChange != null) ? widget.onTextChange! : (BT_Device device, String text) {};
  void Function(BT_Device, String)? get onExecute => (connectable) ? widget.onExecute : null;

  @override
  void initState() {
    super.initState();
    _labelNameController = TextEditingController(text: widget.textDefault);
  }

  Widget _buildExecuteButton(BuildContext context) {
    return IconButton(
      style: styleButtonExecute,
      onPressed: (onExecute != null)
          ? () {
        onExecute!(device, _labelNameController.value.text);
      }
          : null,
      icon: iconButtonExecute,
    );
  }

  @override
  Widget buildTile(BuildContext context) {
    return (device.isConnected)
        ? ExpansionTile(
          collapsedBackgroundColor: widget.colorConnected,
          title: ListTile(
            title: TextField(
              controller: _labelNameController,
              onChanged: (String text) {
                onTextChange(device, text);
              },
            ),
            trailing: _buildExecuteButton(context),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: [
            ListTile(
              leading: rssiText(),
              title: buildTitle(context),
              trailing: buildConnectionButton(context),
            ),
          ],
        )
        : super.buildTile(context);
  }
}