import 'package:equatable/equatable.dart';

abstract class BLERepositoryEvent extends Equatable {
  const BLERepositoryEvent();

  @override
  List<Object?> get props => [];
}

class BLETurnOn extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLETurnOn';
  }
}

class BLEInit extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLEInit';
  }
}

class BLETurnOff extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLETurnOff';
  }
}

class BLEScanOn extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLEScanOn';
  }
}

class BLEScanOff extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLEScanOff';
  }
}

class BLEUpdate extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLEUpdate';
  }
}

class BLEError extends BLERepositoryEvent {
  Exception exception;

  BLEError(this.exception);

  @override
  List<Exception?> get props => [exception];

  @override
  String toString() {
    return 'BLEError: $exception';
  }
}

class BLEDispose extends BLERepositoryEvent {
  @override
  String toString() {
    return 'BLERepositoryDispose';
  }
}