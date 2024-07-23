import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_state.dart';
import 'package:utl_mobile/presentation/utils/show_message.dart';
import 'package:utl_mobile/presentation/utils/snackbar.dart';
import 'package:utl_mobile/presentation/widgets/scanned_ble_tile.dart';

class BLEScanningView extends StatefulWidget {
  BLEScanningView({
    super.key,
    required this.bleRepositoryBloc,
    required this.scannedBLETile,
    this.allowEmptyNameDevice = false,
  });

  bool allowEmptyNameDevice;
  BLERepositoryBloc bleRepositoryBloc;

  Widget Function(BLEDevice device) scannedBLETile;

  @override
  State<BLEScanningView> createState() => _BLEScanningViewState();
}

class _BLEScanningViewState extends State<BLEScanningView> {

  bool get allowEmptyNameDevice => widget.allowEmptyNameDevice;

  Iterable<BLEDevice> get _scanResults {
    if(allowEmptyNameDevice) {
      return bleRepositoryBloc.allDevices;
    } else {
      return bleRepositoryBloc.namedDevices;
    }
  }
  bool get _isScanning => bleRepositoryBloc.isScanning;

  BLERepositoryBloc get bleRepositoryBloc => widget.bleRepositoryBloc;

  Widget Function(BLEDevice device) get scannedBLETile => widget.scannedBLETile;

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
        .map((bleDevice) => scannedBLETile(bleDevice))
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
                  showMsg(context, exception: state.exception);
                }
              }
            },
            child: BlocBuilder<BLERepositoryBloc, BLERepositoryState>(
                bloc: bleRepositoryBloc,
                builder: (context, state) {
                  return ScaffoldMessenger(
                    key: Snackbar.snackBarKeyB,
                    child: Scaffold(
                      // appBar: AppBar(
                      //   title: const Text('Find Devices'),
                      // ),
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