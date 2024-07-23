import 'package:equatable/equatable.dart';

abstract class LineChartState extends Equatable {
  const LineChartState();

  @override
  List<Object?> get props => [];
}

class LineChartStateInit extends LineChartState {
  @override
  List<Object?> get props => [];
}

class LineChartStateNormal extends LineChartState {
  static bool b = false;

  @override
  List<bool> get props {
    b = !b;
    return [b];
  }
}

class LineChartStateDispose extends LineChartState {
  @override
  String toString() {
    return 'LineChartStateDisposeMackayIrb';
  }
}