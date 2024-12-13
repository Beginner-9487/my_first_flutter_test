import 'package:equatable/equatable.dart';

abstract class BluetoothScannerDeviceTileState with EquatableMixin {}

class BluetoothScannerDeviceTileStateInit extends BluetoothScannerDeviceTileState {
  BluetoothScannerDeviceTileStateInit();

  @override
  List<Object?> get props => [];
}

class BluetoothScannerDeviceTileStateNormal extends BluetoothScannerDeviceTileState {
  BluetoothScannerDeviceTileStateNormal({
    required this.name,
    required this.id,
    required this.isConnectable,
    required this.isConnected,
    required this.rssi,
  });

  String name;
  String id;
  bool isConnectable;
  bool isConnected;
  int rssi;

  @override
  List<Object?> get props => [
    name,
    id,
    isConnectable,
    isConnected,
    rssi,
  ];
}
