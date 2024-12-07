import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/bluetooth_scanner_view.dart';

class BluetoothScannerViewImpl extends BluetoothScannerView {
  BluetoothScannerViewImpl({
    super.key,
    required this.provider,
    required this.tileCreator,
    this.filter,
    this.onScanningColor = Colors.red,
    this.onNotScanningColor,
  });
  final BT_Provider provider;
  Widget Function(BT_Device device) tileCreator;
  bool Function(BT_Device device)? filter;

  final Color? onScanningColor;
  final Color? onNotScanningColor;

  final UpdateBloc onScanningStateChangeBloc = UpdateBlocImpl();
  final UpdateBloc onScannedDevicesFoundedBloc = UpdateBlocImpl();

  @override
  void setFilter(bool Function(BT_Device device)? filter) {
    this.filter = filter;
    onScannedDevicesFoundedBloc.update();
  }

  @override
  void setTileCreator(Widget Function(BT_Device device) tileCreator) {
    this.tileCreator = tileCreator;
    onScannedDevicesFoundedBloc.update();
  }

  @override
  State<BluetoothScannerViewImpl> createState() => _BluetoothScannerViewImplState();
}

class _BluetoothScannerViewImplState extends State<BluetoothScannerViewImpl> {
  BT_Provider get provider => widget.provider;
  bool Function(BT_Device device) get filter => (widget.filter != null)
      ? widget.filter!
      : (BT_Device device) => true;
  Widget Function(BT_Device device) get tileCreator => widget.tileCreator;
  Color? get onScanningColor => widget.onScanningColor;
  Color? get onNotScanningColor => widget.onNotScanningColor;

  bool get isScanning => provider.isScanning;

  UpdateBloc get onScanningStateChangeBloc => widget.onScanningStateChangeBloc;
  late StreamSubscription<bool> onScanningStateChange;

  UpdateBloc get onScannedDevicesFoundedBloc => widget.onScannedDevicesFoundedBloc;
  late StreamSubscription<Iterable<BT_Device>> onScanDevices;

  @override
  void initState() {
    super.initState();
    onScanningStateChange = provider.onScanningStateChange((state) {
      onScanningStateChangeBloc.update();
    });
    onScanDevices = provider.onScanDevices((device) {
      onScannedDevicesFoundedBloc.update();
    });
  }

  @override
  void dispose() {
    super.dispose();
    onScanningStateChange.cancel();
    onScanDevices.cancel();
  }

  Future startScanning() async {
    return provider.scanOn();
  }

  Future stopScanning() async {
    return provider.scanOff();
  }

  Future onRefresh() async {
    return startScanning();
  }

  Widget buildScanButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: (isScanning)
          ? stopScanning
          : startScanning,
      backgroundColor: (isScanning)
          ? onScanningColor
          : onNotScanningColor,
      child: (isScanning)
          ? const Icon(Icons.stop)
          : const Icon(Icons.bluetooth_searching),
    );
  }

  Iterable<Widget> _buildScanResultTiles(BuildContext context) {
    return provider
        .devices
        .where((e) => filter(e))
        .map((e) => tileCreator(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocProvider(
            create: (context) => onScannedDevicesFoundedBloc,
            child: BlocBuilder(
                bloc: onScannedDevicesFoundedBloc,
                builder: (context, state) {
                  return ListView(
                    children: <Widget>[
                      ..._buildScanResultTiles(context),
                    ],
                  );
                }
            )
        ),
      ),
      floatingActionButton: BlocProvider(
          create: (context) => onScanningStateChangeBloc,
          child: BlocBuilder(
              bloc: onScanningStateChangeBloc,
              builder: (context, state) {
                return buildScanButton(context);
              }
          )
      ),
    );
  }
}