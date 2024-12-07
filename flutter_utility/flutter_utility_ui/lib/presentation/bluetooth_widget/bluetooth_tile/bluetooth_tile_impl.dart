import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_tile/bluetooth_tile.dart';

class BluetoothTileImpl extends BluetoothTile {
  BluetoothTileImpl({
    super.key,
    required this.device,
    this.onPressConnected,
    this.onPressDisconnected,
    this.colorConnected,
    this.colorDisconnected,
    this.textConnected = "",
    this.textDisconnected = "",
    this.styleButtonConnected,
    this.styleButtonDisconnected,
  });
  BT_Device device;

  Color? colorConnected;
  Color? colorDisconnected;
  String textConnected;
  String textDisconnected;
  void Function(BT_Device device)? onPressConnected;
  void Function(BT_Device device)? onPressDisconnected;
  ButtonStyle? styleButtonConnected;
  ButtonStyle? styleButtonDisconnected;

  @override
  State<BluetoothTileImpl> createState() => BluetoothTileImplState();
}

class BluetoothTileImplState<Tile extends BluetoothTileImpl> extends State<Tile> {
  BT_Device get device => widget.device;

  Color? get colorConnected => widget.colorConnected;
  Color? get colorDisconnected => widget.colorDisconnected;
  String get textConnected => widget.textConnected;
  String get textDisconnected => widget.textDisconnected;

  bool get isConnected => device.isConnected;
  bool get connectable => device.isConnectable;

  ButtonStyle? styleButtonConnected;
  ButtonStyle? styleButtonDisconnected;

  VoidCallback? get onPressConnected {
    if(!connectable) {
      return null;
    }
    return (widget.onPressConnected == null)
        ? () { device.disconnect(); }
        :() { widget.onPressConnected!(device); };
  }
  VoidCallback? get onPressDisconnected {
    if(!connectable) {
      return null;
    }
    return (widget.onPressDisconnected == null)
        ? () { device.connect(); }
        :() { widget.onPressDisconnected!(device); };
  }

  UpdateBloc onRssiChangeBloc = UpdateBlocImpl();
  late StreamSubscription onRssiChange;

  UpdateBloc onConnectStateChangeBloc = UpdateBlocImpl();
  late StreamSubscription onConnectStateChange;

  @override
  void initState() {
    super.initState();
    onConnectStateChange = device.onConnectionStateChange((device) {
      onConnectStateChangeBloc.update();
    });
    onRssiChange = device.onRssiChange((device) {
      onRssiChangeBloc.update();
    });
  }

  @override
  void dispose() {
    super.dispose();
    onRssiChange.cancel();
    onConnectStateChange.cancel();
  }

  Widget buildTitle(BuildContext context) {
    if (device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            device.address,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    } else {
      return Text(device.address.toString());
    }
  }

  Widget buildConnectionButton(BuildContext context) {
    return ElevatedButton(
      style: isConnected
          ? styleButtonConnected
          : styleButtonDisconnected,
      onPressed: isConnected
          ? onPressConnected
          : onPressDisconnected,
      child: isConnected
          ? Text(textConnected)
          : Text(textDisconnected),
    );
  }

  Widget rssiText() {
    return BlocProvider(
        create: (context) => onRssiChangeBloc,
        child: BlocBuilder(
            bloc: onRssiChangeBloc,
            builder: (context, state) {
              return Text(device.rssi.toString());
            }
        )
    );
  }

  Widget buildTile(BuildContext context) {
    return ListTile(
      tileColor: isConnected
          ? colorConnected
          : colorDisconnected,
      title: buildTitle(context),
      leading: rssiText(),
      trailing: buildConnectionButton(context),
      // contentPadding: const EdgeInsets.all(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => onConnectStateChangeBloc,
        child: BlocBuilder(
            bloc: onConnectStateChangeBloc,
            builder: (context, state) {
              return buildTile(context);
            }
        )
    );
  }
}