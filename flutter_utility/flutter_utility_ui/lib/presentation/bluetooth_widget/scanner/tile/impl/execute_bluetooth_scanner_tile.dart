import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_state.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/impl/simple_bluetooth_scanner_tile.dart';

class ExecuteBluetoothScannerTile extends SimpleBluetoothScannerTile {
  ExecuteBluetoothScannerTile({
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
    void Function(BluetoothScannerDeviceTileBloc bloc)? onPressExecute,
    this.executeButtonStyle,
    this.executeButtonIcon = const Icon(Icons.send),
    this.collapsedBackgroundColor,
  }) {
    _onPressExecute = onPressExecute ?? (BluetoothScannerDeviceTileBloc bloc) {};
  }

  late final void Function(BluetoothScannerDeviceTileBloc bloc) _onPressExecute;
  final ButtonStyle? executeButtonStyle;
  final Icon executeButtonIcon;
  final Color? collapsedBackgroundColor;

  @override
  State<ExecuteBluetoothScannerTile> createState() => BluetoothScannerExecuteTileState();
}

class BluetoothScannerExecuteTileState<Tile extends ExecuteBluetoothScannerTile> extends BluetoothScannerSimpleTileState<Tile> {

  void Function(BluetoothScannerDeviceTileBloc bloc) get _onPressExecute => widget._onPressExecute;
  ButtonStyle? get executeButtonStyle => widget.executeButtonStyle;
  Icon get executeButtonIcon => widget.executeButtonIcon;
  Color? get collapsedBackgroundColor => widget.collapsedBackgroundColor;

  Widget buildExecuteButton(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    return IconButton(
      style: executeButtonStyle,
      onPressed: () => _onPressExecute(bloc),
      icon: executeButtonIcon,
    );
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
                collapsedBackgroundColor: collapsedBackgroundColor,
                title: ListTile(
                  title: buildTitle(context, bloc),
                  trailing: buildExecuteButton(context, bloc),
                  contentPadding: const EdgeInsets.all(0.0),
                ),
                children: [
                  ListTile(
                    tileColor: collapsedBackgroundColor,
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