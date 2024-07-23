import 'package:equatable/equatable.dart';

abstract class LineChartEvent extends Equatable {
  const LineChartEvent();

  @override
  List<Object?> get props => [];
}

class LineChartEventError extends LineChartEvent {
  Object exception;

  LineChartEventError(this.exception);

  @override
  List<Object?> get props => [exception];

  @override
  String toString() {
    return 'LineChartEventError';
  }
}

class LineChartEventInit extends LineChartEvent {
  @override
  String toString() {
    return 'LineChartEventInit';
  }
}

class LineChartEventRefresh extends LineChartEvent {
  @override
  String toString() {
    return 'LineChartEventRefresh';
  }
}

class LineChartEventDispose extends LineChartEvent {
  @override
  String toString() {
    return 'LineChartEventDispose';
  }
}

class LineChartEventSetX extends LineChartEvent {
  int? xIndex;

  LineChartEventSetX(this.xIndex);

  @override
  List<Object?> get props => [xIndex];

  @override
  String toString() {
    return 'LineChartEventSetLineChartX: $xIndex';
  }
}

class LineChartEventTouch extends LineChartEvent {
  bool onTouched;

  LineChartEventTouch(this.onTouched);

  @override
  List<Object?> get props => [onTouched];

  @override
  String toString() {
    return 'LineChartEventTouch: $onTouched';
  }
}