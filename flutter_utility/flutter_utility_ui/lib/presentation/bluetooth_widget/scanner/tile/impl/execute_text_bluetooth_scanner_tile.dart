import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/controller/bluetooth_scanner_device_controller.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class ExecuteTextBluetoothScannerTile extends SimpleBluetoothScannerTile {
  ExecuteTextBluetoothScannerTile({
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
    this.onTextChange,
    String defaultText = "",
  }) : _text = defaultText;

  final void Function(BluetoothScannerDeviceTileController controller, String text)? onPressExecute;
  final ButtonStyle? executeButtonStyle;
  final Icon executeButtonIcon;
  final Color? collapsedBackgroundColor;

  final void Function(BluetoothScannerDeviceTileController controller, String text)? onTextChange;
  String _text;
  String get text => _text;

  @override
  State<ExecuteTextBluetoothScannerTile> createState() => BluetoothScannerExecuteTextTileState();
}

class BluetoothScannerExecuteTextTileState<Tile extends ExecuteTextBluetoothScannerTile> extends BluetoothScannerSimpleTileState<Tile> {

  late final TextEditingController _labelNameController;
  ButtonStyle? get executeButtonStyle => widget.executeButtonStyle;
  Icon get executeButtonIcon => widget.executeButtonIcon;
  Color? get collapsedBackgroundColor => widget.collapsedBackgroundColor;
  set text(String text) => widget._text = text;
  String get text => widget._text;

  Widget get buildExecuteButton => IconButton(
    style: executeButtonStyle,
    onPressed: () {
      if (widget.onPressExecute != null) {
        widget.onPressExecute!(controller, widget._text);
      }
    },
    icon: executeButtonIcon,
  );

  @mustCallSuper
  @override
  void initState() {
    _labelNameController = TextEditingController(text: text);
    return super.initState();
  }

  @override
  Widget get buildTile => ValueListenableBuilder<bool>(
    valueListenable: connectionNotifier,
    builder: (context, isConnected, child) {
      return (isConnected)
        ? ExpansionTile(
          collapsedBackgroundColor: widget.connectedTileBackgroundColor,
          title: ListTile(
            title: TextField(
              controller: _labelNameController,
              onChanged: (text) {
                this.text = text;
                if (widget.onTextChange != null) {
                  widget.onTextChange!(controller, text);
                }
              },
            ),
            trailing: buildExecuteButton,
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: [
            ListTile(
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