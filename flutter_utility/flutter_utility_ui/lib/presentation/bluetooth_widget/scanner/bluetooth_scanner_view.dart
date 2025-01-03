import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/bluetooth_widget/scanner/controller/bluetooth_scanner_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScannerView<Device> extends StatefulWidget {
  const BluetoothScannerView({
    super.key,
    required this.controller,
    required this.deviceTileBuilder,
    this.filter,
    this.disableView,
    required this.scanButtonOnScanningColor,
    required this.scanButtonOnNotScanningColor,
  });
  final BluetoothScannerController<Device> controller;
  final Widget Function(Device device) deviceTileBuilder;
  final bool Function(Device device)? filter;

  final Widget? disableView;

  final Color? scanButtonOnScanningColor;
  final Color? scanButtonOnNotScanningColor;

  @override
  State<BluetoothScannerView<Device>> createState() => _BluetoothScannerViewState<Device>();
}

class _BluetoothScannerViewState<Device> extends State<BluetoothScannerView<Device>> {
  BluetoothScannerController<Device> get controller => widget.controller;
  Widget Function(Device device) get deviceTileBuilder => widget.deviceTileBuilder;
  bool Function(Device device) get filter => (widget.filter != null)
      ? widget.filter!
      : (Device device) => true;

  Widget get disableView => widget.disableView ?? buildEnableScreen;
  Color? get scanButtonOnScanningColor => widget.scanButtonOnScanningColor;
  Color? get scanButtonOnNotScanningColor => widget.scanButtonOnNotScanningColor;

  late final StreamSubscription<bool> _onEnableStateChange;
  late final ValueNotifier<bool> onEnableValueNotifier;
  late final StreamSubscription<bool> _onScanningStateChange;
  late final ValueNotifier<bool> onScanningValueNotifier;
  late final StreamSubscription<Device> _onFoundNewDevice;
  late final ValueNotifier<List<Device>> devicesValueNotifier;

  Future<bool> requestPermission() async {
    if(!(await Permission.bluetooth.isGranted)) {
      if(!(await Permission.bluetooth.request().isGranted)) {
        return false;
      }
    }
    if(!(await Permission.location.isGranted)) {
      if(!(await Permission.location.request().isGranted)) {
        return false;
      }
    }
    return true;
  }
  Future onRefresh() async {
    if(await requestPermission()) {
      return controller.scanOff().then((value) => controller.scanOn());
    }
  }
  Future toggleBluetoothScanning() async {
    if(await requestPermission()) {
      return controller.isScanning
        ? controller.scanOff()
        : controller.scanOn();
    }
  }
  Widget get buildScanButton => ValueListenableBuilder(
      valueListenable: onScanningValueNotifier,
      builder: (context, isScanning, child) {
        return FloatingActionButton(
          onPressed: toggleBluetoothScanning,
          backgroundColor: (isScanning)
              ? scanButtonOnScanningColor
              : scanButtonOnNotScanningColor,
          child: (controller.isScanning)
              ? const Icon(Icons.stop)
              : const Icon(Icons.bluetooth_searching),
        );
      }
  );
  final Key tilesKey = UniqueKey();
  Widget get buildTiles => ValueListenableBuilder(
      valueListenable: devicesValueNotifier,
      builder: (context, devices, child) {
        return ListView.builder(
          key: tilesKey,
          itemCount: controller.devices.where(filter).length,
          itemBuilder: (context, index) {
            return deviceTileBuilder(
                controller
                    .devices
                    .where(filter)
                    .skip(index)
                    .first
            );
          },
        );
      }
  );
  Widget get buildEnableScreen => Scaffold(
    body: RefreshIndicator(
      onRefresh: onRefresh,
      child: buildTiles,
    ),
    floatingActionButton: buildScanButton,
  );
  Widget get buildMainScreen => ValueListenableBuilder(
    valueListenable: onEnableValueNotifier,
    builder: (context, isEnable, child) {
      return (isEnable)
        ? child!
        : disableView;
    },
    child: buildEnableScreen,
  );

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    onEnableValueNotifier = ValueNotifier(controller.isEnable);
    _onEnableStateChange = controller.onEnableStateChange.listen((enable) {
      onEnableValueNotifier.value = enable;
    });
    onScanningValueNotifier = ValueNotifier(controller.isScanning);
    _onScanningStateChange = controller.onScanningStateChange.listen((isScanning) {
      onScanningValueNotifier.value = isScanning;
    });
    devicesValueNotifier = ValueNotifier(controller.devices.toList());
    _onFoundNewDevice = controller.onFoundNewDevice.listen((device) {
      devicesValueNotifier.value = controller.devices.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildMainScreen;
  }

  @mustCallSuper
  @override
  void dispose() {
    _onEnableStateChange.cancel();
    _onScanningStateChange.cancel();
    _onFoundNewDevice.cancel();
    return super.dispose();
  }

}
