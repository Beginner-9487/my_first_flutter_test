import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_event.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bloc/bluetooth_scanner_device_tile_state.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/tile/bluetooth_scanner_tile.dart';

class SimpleBluetoothScannerTile<Device> extends BluetoothScannerTile<Device> {
  SimpleBluetoothScannerTile({
    super.key,
    required super.device,
    this.connectedTileBackgroundColor,
    this.disconnectedTileBackgroundColor,
    this.textConnected = "Disconnect",
    this.textDisconnected = "Connect",
    void Function(BluetoothScannerDeviceTileBloc bloc)? onPressConnected,
    void Function(BluetoothScannerDeviceTileBloc bloc)? onPressDisconnected,
    this.connectedButtonStyle,
    this.disconnectedButtonStyle,
    this.contentPadding,
  }) {
    _onPressConnected = onPressConnected ??
            (bloc) => bloc.add(BluetoothScannerDeviceTileEventToggleConnection());
    _onPressDisconnected = onPressDisconnected ??
            (bloc) => bloc.add(BluetoothScannerDeviceTileEventToggleConnection());
  }

  final Color? connectedTileBackgroundColor;
  final Color? disconnectedTileBackgroundColor;
  final String textConnected;
  final String textDisconnected;
  late final void Function(BluetoothScannerDeviceTileBloc bloc) _onPressConnected;
  late final void Function(BluetoothScannerDeviceTileBloc bloc) _onPressDisconnected;
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
  void Function(BluetoothScannerDeviceTileBloc bloc) get _onPressConnected => widget._onPressConnected;
  void Function(BluetoothScannerDeviceTileBloc bloc) get _onPressDisconnected => widget._onPressDisconnected;
  ButtonStyle? get connectedButtonStyle => widget.connectedButtonStyle;
  ButtonStyle? get disconnectedButtonStyle => widget.disconnectedButtonStyle;
  EdgeInsetsGeometry? get contentPadding => widget.contentPadding;

  VoidCallback? onPressConnectedVoidCallback(BluetoothScannerDeviceTileBloc bloc) {
    if(bloc.state is BluetoothScannerDeviceTileStateNormal && (bloc.state as BluetoothScannerDeviceTileStateNormal).isConnectable) {
      return () => _onPressConnected(bloc);
    }
    return null;
  }
  VoidCallback? onPressDisconnectedVoidCallback(BluetoothScannerDeviceTileBloc bloc) {
    if(bloc.state is BluetoothScannerDeviceTileStateNormal && (bloc.state as BluetoothScannerDeviceTileStateNormal).isConnectable) {
      return () => _onPressDisconnected(bloc);
    }
    return null;
  }

  Widget buildTitle(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    BluetoothScannerDeviceTileStateNormal state = bloc.state as BluetoothScannerDeviceTileStateNormal;
    if (state.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            state.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            state.id,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    } else {
      return Text(state.id);
    }
  }

  Widget buildConnectionButton(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    return BlocBuilder<BluetoothScannerDeviceTileBloc, BluetoothScannerDeviceTileState>(
      buildWhen: (previous, current) {
        return (
            current is BluetoothScannerDeviceTileStateNormal
                && previous is! BluetoothScannerDeviceTileStateNormal
        )
            || (
                current is BluetoothScannerDeviceTileStateNormal
                    && previous is BluetoothScannerDeviceTileStateNormal
                    && (
                    current.isConnected != previous.isConnected
                        || current.isConnectable != previous.isConnectable
                )
            );
      },
      builder: (context, state) {
        BluetoothScannerDeviceTileStateNormal state = bloc.state as BluetoothScannerDeviceTileStateNormal;
        return ElevatedButton(
          style: state.isConnected
              ? connectedButtonStyle
              : disconnectedButtonStyle,
          onPressed: state.isConnected
              ? onPressConnectedVoidCallback(bloc)
              : onPressDisconnectedVoidCallback(bloc),
          child: state.isConnected
              ? Text(textConnected)
              : Text(textDisconnected),
        );
      },
    );
  }

  Widget rssiText(BluetoothScannerDeviceTileBloc bloc) {
    return BlocBuilder(
      buildWhen: (previous, current) {
        return (
            current is BluetoothScannerDeviceTileStateNormal
                && previous is! BluetoothScannerDeviceTileStateNormal
        )
            || (
                current is BluetoothScannerDeviceTileStateNormal
                    && previous is BluetoothScannerDeviceTileStateNormal
                    && current.rssi != previous.rssi
            );
      },
      builder: (context, state) {
        BluetoothScannerDeviceTileStateNormal state = bloc.state as BluetoothScannerDeviceTileStateNormal;
        return Text(state.rssi.toString());
      },
    );
  }

  Widget buildTile(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
    BluetoothScannerDeviceTileStateNormal state = bloc.state as BluetoothScannerDeviceTileStateNormal;
    return ListTile(
      tileColor: (state.isConnected)
          ? connectedTileBackgroundColor
          : disconnectedTileBackgroundColor,
      title: buildTitle(context, bloc),
      leading: rssiText(bloc),
      trailing: buildConnectionButton(context, bloc),
      contentPadding: contentPadding,
    );
  }

  @override
  BlocBuilder<BluetoothScannerDeviceTileBloc, BluetoothScannerDeviceTileState> builder(BuildContext context, BluetoothScannerDeviceTileBloc bloc) {
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
      builder: (BuildContext context, BluetoothScannerDeviceTileState state) {
        return buildTile(context, bloc);
      },
    );
  }

}
