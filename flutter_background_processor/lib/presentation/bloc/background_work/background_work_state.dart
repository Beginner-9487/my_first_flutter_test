import 'package:equatable/equatable.dart';

abstract class BackgroundWorkState extends Equatable {
  const BackgroundWorkState();

  @override
  List<Object?> get props => [];
}

class BackgroundWorkNormalState extends BackgroundWorkState {
  static bool b = false;

  @override
  List<bool> get props {
    b = !b;
    return [b];
  }

  @override
  String toString() {
    return 'BackgroundWorkNormalState';
  }
}

class BackgroundWorkErrorState extends BackgroundWorkState {
  Exception exception;

  BackgroundWorkErrorState(this.exception);

  @override
  List<Exception?> get props => [exception];

  @override
  String toString() {
    return 'BackgroundWorkErrorState: $exception';
  }
}

class BackgroundWorkDisposeState extends BackgroundWorkState {
  @override
  String toString() {
    return 'BackgroundWorkDisposeState';
  }
}