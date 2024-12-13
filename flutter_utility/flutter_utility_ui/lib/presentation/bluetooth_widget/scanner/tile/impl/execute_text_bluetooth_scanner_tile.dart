import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_state.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class ExecuteTextBluetoothScannerTile extends SimpleBluetoothScannerTile {
  ExecuteTextBluetoothScannerTile({
    super.key,
    required super.device,
    super.connectedTileBackgroundColor,
    super.disconnectedTileBackgroundColor,
    super.textConnected,
    super.textDisconnected,
    super.onPressConnected,
    super.onPressDisconnected,
    super.connectedButtonStyle,
    super.disconnectedButtonStyle,
    void Function(BluetoothScannerDeviceTileBloc bloc, String text)? onPressExecute,
    this.executeButtonStyle,
    this.executeButtonIcon = const Icon(Icons.send),
    this.collapsedBackgroundColor,
    void Function(BluetoothScannerDeviceTileBloc bloc, String text)? onTextChange,
    String defaultText = "",
  }) {
    _onPressExecute = onPressExecute ?? (BluetoothScannerDeviceTileBloc bloc, String text) {};
    _onTextChange = onTextChange ?? (BluetoothScannerDeviceTileBloc bloc, String text) {};
    _text = defaultText;
  }

  late final void Function(BluetoothScannerDeviceTileBloc bloc, String text) _onPressExecute;
  final ButtonStyle? executeButtonStyle;
  final Icon executeButtonIcon;
  final Color? collapsedBackgroundColor;

  late final void Function(BluetoothScannerDeviceTileBloc bloc, String text) _onTextChange;
  late String _text;
  String get text => _text;

  @override
  State<ExecuteTextBluetoothScannerTile> createState() => BluetoothScannerExecuteTextTileState();
}

class BluetoothScannerExecuteTextTileState<Tile extends ExecuteTextBluetoothScannerTile> extends BluetoothScannerSimpleTileState<Tile> {

  late TextEditingController _labelNameController;

  void Function(BluetoothScannerDeviceTileBloc bloc, String text) get onTextChange => (bloc, text) {
    widget._text = text;
    widget._onTextChange(bloc, text);
  };

  void Function(BluetoothScannerDeviceTileBloc bloc, String text) get _onPressExecute => widget._onPressExecute;
  ButtonStyle? get executeButtonStyle => widget.executeButtonStyle;
  Icon get executeButtonIcon => widget.executeButtonIcon;
  Color? get collapsedBackgroundColor => widget.collapsedBackgroundColor;

  Widget buildExecuteButton(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    return IconButton(
      style: executeButtonStyle,
      onPressed: () => _onPressExecute(bloc, widget._text),
      icon: executeButtonIcon,
    );
  }

  @override
  void initState() {
    super.initState();
    _labelNameController = TextEditingController(text: widget._text);
  }

  @override
  Widget buildTile(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    return BlocBuilder<BluetoothScannerDeviceTileBloc, BluetoothScannerDeviceTileState>(
      buildWhen: (previous, current) {
        return (
            current is BluetoothScannerDeviceTileStateNormal
                && previous is! BluetoothScannerDeviceTileStateNormal
        )
            || (
                current is BluetoothScannerDeviceTileStateNormal
                    && previous is BluetoothScannerDeviceTileStateNormal
                    && current.isConnected != previous.isConnected
            );
      },
      builder: (context, state) {
        BluetoothScannerDeviceTileStateNormal state = bloc.state as BluetoothScannerDeviceTileStateNormal;
        return (state.isConnected)
            ? ExpansionTile(
          collapsedBackgroundColor: widget.connectedTileBackgroundColor,
          title: ListTile(
            title: TextField(
              controller: _labelNameController,
              onChanged: (text) => onTextChange(bloc, text),
            ),
            trailing: buildExecuteButton(context, bloc),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: [
            ListTile(
              leading: rssiText(bloc),
              title: buildTitle(context, bloc),
              trailing: buildConnectionButton(context, bloc),
            ),
          ],
        )
            : super.buildTile(context, bloc);
      },
    );
  }
}