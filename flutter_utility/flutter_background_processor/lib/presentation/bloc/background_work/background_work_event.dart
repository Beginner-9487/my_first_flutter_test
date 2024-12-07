import 'package:equatable/equatable.dart';

abstract class BackgroundWorkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BackgroundWorkStart extends BackgroundWorkEvent {
  @override
  String toString() {
    return 'BackgroundWorkStart';
  }
}

class BackgroundWorkStop extends BackgroundWorkEvent {
  @override
  String toString() {
    return 'BackgroundWorkStop';
  }
}

class BackgroundWorkUpdate extends BackgroundWorkEvent {
  @override
  String toString() {
    return 'BackgroundWorkUpdate';
  }
}

class BackgroundWorkDispose extends BackgroundWorkEvent {
  @override
  String toString() {
    return 'BackgroundWorkDispose';
  }
}