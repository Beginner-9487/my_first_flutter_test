import 'package:equatable/equatable.dart';

abstract class BluetoothScannerState with EquatableMixin {}

class BluetoothScannerStateInit extends BluetoothScannerState {
  BluetoothScannerStateInit();

  @override
  List<Object?> get props => [];
}

class BluetoothScannerStateDisable extends BluetoothScannerState {
  BluetoothScannerStateDisable();

  @override
  List<Object?> get props => [];
}

class BluetoothScannerStateEnable<Device> extends BluetoothScannerState {
  BluetoothScannerStateEnable({
    required this.isScanning,
    required this.devices,
  });

  bool isScanning;
  Iterable<Device> devices;

  @override
  List<Object?> get props => [
    isScanning,
    ...devices,
  ];
}
