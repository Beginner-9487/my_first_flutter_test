import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_ble/presentation/bloc/device/ble_device_bloc.dart';
import 'package:test_ble/presentation/bloc/repository/ble_repository_bloc.dart';
import 'package:test_ble/presentation/bloc/repository/ble_repository_event.dart';
import 'package:test_ble/presentation/bloc/repository/ble_repository_state.dart';
import 'package:test_ble/presentation/utils/snack_bar.dart';
import 'package:test_ble/presentation/widgets/scanned_ble_tile.dart';
import 'package:test_ble/resources/app_theme.dart';

class BLEScanningView extends StatefulWidget {
  BLEScanningView({
    super.key,
    required this.bleRepositoryBloc,
  });

  BLERepositoryBloc bleRepositoryBloc;

  @override
  State<BLEScanningView> createState() => _BLEScanningViewState();
}

class _BLEScanningViewState extends State<BLEScanningView> {

  Iterable get _scanResults => bleRepositoryBloc.devices;
  bool get _isScanning => bleRepositoryBloc.isScanning;

  BLERepositoryBloc get bleRepositoryBloc => widget.bleRepositoryBloc;

  @override
  void initState() {
    super.initState();
    bleRepositoryBloc.add(BLEInit());
  }

  @override
  void dispose() {
    // bleRepositoryBloc.add(BLEDispose());
    super.dispose();
  }

  Future onScanPressed() async {
    bleRepositoryBloc.add(BLEScanOn());
  }

  Future onStopPressed() async {
    bleRepositoryBloc.add(BLEScanOff());
  }

  Future onRefresh() async {
    bleRepositoryBloc.add(BLEScanOn());
    // return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (_isScanning) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          onPressed: onScanPressed,
          child: const Icon(Icons.bluetooth_searching)
      );
    }
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map((bleDevice) => ScannedBLETile(
          bleDeviceBloc: BLEDeviceBloc(bleDevice),
        ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BLERepositoryBloc>(
              create: (BuildContext context) => bleRepositoryBloc
          ),
        ],
        child: BlocListener(
            bloc: bleRepositoryBloc,
            listener: (context, state) {
              if (state is BLEErrorState) {
                if (context != null) {
                  AppTheme.showMsg(context, exception: state.exception);
                }
              }
            },
            child: BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
                bloc: bleRepositoryBloc,
                builder: (context, state) {
                  return ScaffoldMessenger(
                    key: MessageSnackBar.snackBarKeyB,
                    child: Scaffold(
                      appBar: AppBar(
                        title: const Text('Find Devices'),
                      ),
                      body: RefreshIndicator(
                        onRefresh: onRefresh,
                        child: ListView(
                          children: <Widget>[
                            ..._buildScanResultTiles(context),
                          ],
                        ),
                      ),
                      floatingActionButton: buildScanButton(context),
                    ),
                  );
                }
            )
        )
    );
  }
}