import 'package:equatable/equatable.dart';

abstract class BLERepositoryState extends Equatable {
  const BLERepositoryState();

  @override
  List<Object?> get props => [];
}

class BLENormalState extends BLERepositoryState {
  static bool b = false;

  @override
  List<bool> get props {
    b = !b;
    return [b];
  }

  @override
  String toString() {
    return 'BLENormalState';
  }
}

class BLEErrorState extends BLERepositoryState {
  Exception exception;

  BLEErrorState(this.exception);

  @override
  List<Exception?> get props => [exception];

  @override
  String toString() {
    return 'BLEError: $exception';
  }
}

class BLEDisposeState extends BLERepositoryState {
  @override
  String toString() {
    return 'BLEDisposeState';
  }
}