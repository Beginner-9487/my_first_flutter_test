import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_state.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class ButtonsBluetoothScannerTile<Device> extends SimpleBluetoothScannerTile<Device> {
  ButtonsBluetoothScannerTile({
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
    required this.buttons,
  });

  Map<Icon, void Function(BluetoothScannerDeviceTileBloc bloc)> buttons;

  @override
  State<ButtonsBluetoothScannerTile> createState() => BluetoothScannerButtonsTileState();
}

class BluetoothScannerButtonsTileState<Tile extends ButtonsBluetoothScannerTile> extends BluetoothScannerSimpleTileState<Tile> {
  Map<Icon, void Function(BluetoothScannerDeviceTileBloc bloc)> get buttons => widget.buttons;

  Widget _buildButtons(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    return Row(
      children: buttons.entries.map((e) => IconButton(
        onPressed: () {
          e.value(bloc);
        },
        icon: e.key,
      )).toList(),
    );
  }

  @override
  Widget buildTile(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    BluetoothScannerDeviceTileStateNormal state = bloc.state as BluetoothScannerDeviceTileStateNormal;
    return (state.isConnected)
        ? ListView(
            children: [
              ListTile(
                leading: rssiText(bloc),
                title: buildTitle(context, bloc),
                trailing: buildConnectionButton(context, bloc),
              ),
              _buildButtons(context, bloc),
            ],
          )
        : super.buildTile(context, bloc);
  }
}
