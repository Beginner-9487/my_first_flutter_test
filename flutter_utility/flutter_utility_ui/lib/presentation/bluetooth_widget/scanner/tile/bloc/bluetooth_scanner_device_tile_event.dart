import 'package:equatable/equatable.dart';

abstract class BluetoothScannerDeviceTileEvent with EquatableMixin {}

abstract class BluetoothScannerDeviceTileEventConnection extends BluetoothScannerDeviceTileEvent {}

class BluetoothScannerDeviceTileEventToggleConnection extends BluetoothScannerDeviceTileEventConnection {
  BluetoothScannerDeviceTileEventToggleConnection();

  @override
  List<Object?> get props => [];
}
