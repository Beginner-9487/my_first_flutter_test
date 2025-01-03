import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/line_chart/line_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionLineChartDatasetController extends LineChartDatasetController<List<LineSeries<Point, double>>> {
  SyncfusionLineChartDatasetController({
    required List<LineSeries<Point, double>> dataset,
  }) : datasetNotifier = ValueNotifier(dataset);
  @override
  final ValueNotifier<List<LineSeries<Point, double>>> datasetNotifier;
  @override
  set dataset(List<LineSeries<Point, double>> dataset) {
    datasetNotifier.value = dataset;
  }
  @override
  List<LineSeries<Point, double>> get dataset => datasetNotifier.value;
}

class SyncfusionLineChartTouchState extends LineChartTouchState {
  @override
  final double? x;
  @override
  final LineChartTouchStateType type;
  @override
  bool get isTouched => type == LineChartTouchStateType.down || type == LineChartTouchStateType.move;
  SyncfusionLineChartTouchState({
    this.x,
    required this.type,
  });
}

class SyncfusionLineChart extends StatelessWidget implements LineChart<List<LineSeries<Point, double>>> {
  SyncfusionLineChart({
    super.key,
    this.datasetController,
    this.onTouchStateChanged,
    this.primaryYAxis,
    this.trackballBehavior,
    this.zoomPanBehavior,
  });
  final ChartAxis? primaryYAxis;
  final TrackballBehavior? trackballBehavior;
  final ZoomPanBehavior? zoomPanBehavior;
  late final ValueListenableBuilder<List<LineSeries<Point, double>>> view;
  double? _latestX;
  @override
  double? get latestX => _latestX;
  @override
  final SyncfusionLineChartDatasetController? datasetController;
  @override
  void Function(LineChartTouchState oldTouchState, LineChartTouchState newTouchState)? onTouchStateChanged;
  LineChartTouchState _oldTouchState = SyncfusionLineChartTouchState(
      type: LineChartTouchStateType.up,
  );
  @override
  LineChartTouchState get oldTouchState => _oldTouchState;
  LineChartTouchState _newTouchState = SyncfusionLineChartTouchState(
    type: LineChartTouchStateType.up,
  );
  List<LineSeries<Point<num>, double>> get series => datasetController?.dataset ?? [];
  @override
  LineChartTouchState get newTouchState => _newTouchState;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<LineSeries<Point, double>>>(
      valueListenable: datasetController?.datasetNotifier ?? ValueNotifier([]),
      builder: (context, rssi, child) {
        return SfCartesianChart(
          series: series,
          trackballBehavior: trackballBehavior,
          zoomPanBehavior: zoomPanBehavior,
          onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
            _oldTouchState = newTouchState;
            _newTouchState = SyncfusionLineChartTouchState(
              type: LineChartTouchStateType.down,
            );
            if(onTouchStateChanged != null) onTouchStateChanged!(oldTouchState, newTouchState);
          },
          onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
            _oldTouchState = newTouchState;
            _newTouchState = SyncfusionLineChartTouchState(
              type: LineChartTouchStateType.up,
            );
            if(onTouchStateChanged != null) onTouchStateChanged!(oldTouchState, newTouchState);
          },
          onTrackballPositionChanging: (TrackballArgs trackballArgs) {
            int? seriesIndex = trackballArgs.chartPointInfo.seriesIndex;
            int? dataPointIndex = trackballArgs.chartPointInfo.dataPointIndex;
            double? x;
            if(seriesIndex != null && dataPointIndex != null) {
              x = series
                  .skip(trackballArgs.chartPointInfo.seriesIndex!)
                  .firstOrNull
                  ?.dataSource
                  ?.skip(trackballArgs.chartPointInfo.dataPointIndex!)
                  .firstOrNull
                  ?.x
                  .toDouble();
            }
            _latestX = (x != null) ? x : _latestX;
            _oldTouchState = newTouchState;
            _newTouchState = SyncfusionLineChartTouchState(
              type: LineChartTouchStateType.move,
              x: x,
            );
            if(onTouchStateChanged != null) onTouchStateChanged!(oldTouchState, newTouchState);
          },
          primaryYAxis: primaryYAxis ?? const NumericAxis(),
        );
      },
    );
  }
}
