import 'package:flutter/material.dart';

abstract class LineChartDatasetController<Dataset> {
  set dataset(Dataset dataset);
  Dataset get dataset;
  ValueNotifier<Dataset> get datasetNotifier;
}

abstract class LineChartTouchState {
  double? get x;
  LineChartTouchStateType get type;
  bool get isTouched;
}

enum LineChartTouchStateType {
  down,
  up,
  move,
}

abstract class LineChart<Dataset> extends Widget {
  const LineChart({
    super.key,
    this.datasetController,
    this.onTouchStateChanged,
  });
  final LineChartDatasetController<Dataset>? datasetController;
  final void Function(LineChartTouchState oldTouchState, LineChartTouchState newTouchState)? onTouchStateChanged;
  double? get latestX;
  LineChartTouchState get oldTouchState;
  LineChartTouchState get newTouchState;
}
