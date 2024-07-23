import 'package:equatable/equatable.dart';

abstract class BLEDeviceEvent extends Equatable {
  const BLEDeviceEvent();

  @override
  List<Object?> get props => [];
}

class BLEDeviceConnect extends BLEDeviceEvent {
  @override
  String toString() {
    return 'BLEDeviceConnect';
  }
}

class BLEDeviceDisconnect extends BLEDeviceEvent {
  @override
  String toString() {
    return 'BLEDeviceDisconnect';
  }
}

class BLEDeviceDiscoverServices extends BLEDeviceEvent {
  @override
  String toString() {
    return 'BLEDeviceDiscoverServices';
  }
}

class BLEDeviceEventDispose extends BLEDeviceEvent {
  @override
  String toString() {
    return 'BLEDeviceEventDispose';
  }
}