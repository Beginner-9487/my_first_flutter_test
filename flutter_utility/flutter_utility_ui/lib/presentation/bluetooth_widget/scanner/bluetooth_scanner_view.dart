import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_bloc.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_event.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/bloc/bluetooth_scanner_state.dart';

class BluetoothScannerView<Device> extends StatefulWidget {
  BluetoothScannerView({
    super.key,
    required this.controller,
    required this.deviceTileBuilder,
    required this.filter,
    required this.lockViewBuilder,
    required this.scanDelay,
    required this.scanButtonOnScanningColor,
    required this.scanButtonOnNotScanningColor,
  });
  BluetoothScannerController<Device> controller;
  Widget Function(Device device) deviceTileBuilder;
  bool Function(Device device)? filter;

  Widget Function() lockViewBuilder;

  Duration scanDelay;

  Color? scanButtonOnScanningColor;
  Color? scanButtonOnNotScanningColor;

  @override
  State<BluetoothScannerView<Device>> createState() => _BluetoothScannerViewState<Device>();
}

class _BluetoothScannerViewState<Device> extends State<BluetoothScannerView<Device>> {
  late final BluetoothScannerBloc<Device> bloc;
  Iterable<Device> get devices => bloc.devices;

  Duration get scanDelay => widget.scanDelay;

  bool Function(Device device) get filter => (widget.filter != null)
      ? widget.filter!
      : (Device device) => true;

  bool get isScanning => bloc.isScanning;
  Color? get scanButtonOnScanningColor => widget.scanButtonOnScanningColor;
  Color? get scanButtonOnNotScanningColor => widget.scanButtonOnNotScanningColor;

  Widget Function(Device device) get deviceTileBuilder => widget.deviceTileBuilder;
  Widget Function() get lockViewBuilder => widget.lockViewBuilder;

  @override
  void initState() {
    super.initState();
    bloc = BluetoothScannerBloc(
      controller: widget.controller,
      scanDelay: scanDelay,
    );
  }

  Future _toggleScanning() async {
    return bloc.add(BluetoothScannerEventToggleScanning());
  }

  Future _onRefresh() async {
    return bloc.add(BluetoothScannerEventRefreshScanning());
  }

  Widget buildScanButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: _toggleScanning,
      backgroundColor: (isScanning)
          ? scanButtonOnScanningColor
          : scanButtonOnNotScanningColor,
      child: (isScanning)
          ? const Icon(Icons.stop)
          : const Icon(Icons.bluetooth_searching),
    );
  }

  Iterable<Widget> _buildScanResultTiles(BuildContext context) {
    return devices
        .where((e) => filter(e))
        .map((e) => deviceTileBuilder(e));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder<BluetoothScannerBloc, BluetoothScannerState>(
        builder: (context, state) {
          if(state is BluetoothScannerStateEnable) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: BlocBuilder<BluetoothScannerBloc, BluetoothScannerState>(
                  buildWhen: (previous, current) {
                    return current is BluetoothScannerStateEnable;
                  },
                  builder: (context, state) {
                    return ListView(
                      children: <Widget>[
                        ..._buildScanResultTiles(context),
                      ],
                    );
                  },
                ),
              ),
              floatingActionButton: BlocBuilder<BluetoothScannerBloc, BluetoothScannerState>(
                buildWhen: (previous, current) {
                  return current is BluetoothScannerStateEnable;
                },
                builder: (context, state) {
                  return buildScanButton(context);
                },
              ),
            );
          }
          if(state is BluetoothScannerStateDisable) {
            return lockViewBuilder();
          }
          return const Scaffold();
        },
      ),
    );
  }
}