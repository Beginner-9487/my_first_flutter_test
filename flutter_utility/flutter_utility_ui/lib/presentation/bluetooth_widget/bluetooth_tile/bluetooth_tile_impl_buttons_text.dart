import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_tile/bluetooth_tile_impl.dart';

class BluetoothTileImplButtonsText extends BluetoothTileImpl {
  BluetoothTileImplButtonsText({
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
    required this.buttons,
    this.styleButtonExecute,
    this.colorOpen,
    this.onTextChange,
    this.textDefault = "",
  });

  Map<Icon, void Function(BT_Device, String)> buttons;
  ButtonStyle? styleButtonExecute;
  Color? colorOpen;

  void Function(BT_Device, String)? onTextChange;
  String textDefault;

  @override
  State<BluetoothTileImplButtonsText> createState() => BluetoothTileImplButtonsTextState();
}

class BluetoothTileImplButtonsTextState<Tile extends BluetoothTileImplButtonsText> extends BluetoothTileImplState<Tile> {
  late TextEditingController _labelNameController;

  ButtonStyle? get styleButtonExecute => widget.styleButtonExecute;
  Color? get colorOpen => widget.colorOpen;

  void Function(BT_Device, String) get onTextChange => (widget.onTextChange != null) ? widget.onTextChange! : (BT_Device device, String text) {};

  Map<Icon, void Function(BT_Device, String)> get buttons => widget.buttons;

  @override
  void initState() {
    super.initState();
    _labelNameController = TextEditingController(text: widget.textDefault);
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: buttons.entries.map((e) => IconButton(
          onPressed: () {
            e.value(
                device,
                _labelNameController.value.text,
            );
          },
          icon: e.key,
      )).toList(),
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
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: [
            ListTile(
              leading: rssiText(),
              title: buildTitle(context),
              trailing: buildConnectionButton(context),
            ),
            _buildButtons(context),
          ],
        )
        : super.buildTile(context);
  }
}