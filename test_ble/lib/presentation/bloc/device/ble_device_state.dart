import 'package:equatable/equatable.dart';

abstract class BLEDeviceState extends Equatable {
  const BLEDeviceState();

  @override
  List<Object?> get props => [];
}

class BLEDeviceNormalState extends BLEDeviceState {
  static bool b = false;

  @override
  List<bool> get props {
    b = !b;
    return [b];
  }

  @override
  String toString() {
    return 'BLEDeviceNormalState';
  }
}

class BLEDeviceErrorState extends BLEDeviceState {
  Object exception;

  BLEDeviceErrorState(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'BLEDeviceErrorState: $exception';
  }
}

class BLEDeviceStateDispose extends BLEDeviceState {
  @override
  String toString() {
    return 'BLEDeviceStateDispose';
  }
}