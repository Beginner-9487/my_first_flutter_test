import 'package:equatable/equatable.dart';

abstract class BluetoothScannerEvent with EquatableMixin {}

abstract class BluetoothScannerEventScanning extends BluetoothScannerEvent {}

class BluetoothScannerEventToggleScanning extends BluetoothScannerEventScanning {
  BluetoothScannerEventToggleScanning();

  @override
  List<Object?> get props => [];
}

class BluetoothScannerEventRefreshScanning extends BluetoothScannerEventScanning {
  BluetoothScannerEventRefreshScanning();

  @override
  List<Object?> get props => [];
}
