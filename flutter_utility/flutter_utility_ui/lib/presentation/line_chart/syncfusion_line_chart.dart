import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_utility_ui/presentation/line_chart/line_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncfusionLineChart extends LineChart<List<LineSeries<Point, double>>> {
  SyncfusionLineChart({
    super.key,
    this.primaryYAxis,
    this.trackballBehavior,
    this.zoomPanBehavior,
    List<LineSeries<Point, double>> dataset = const [],
  }) {
    _dataset = dataset;
    _controller = StreamController.broadcast();
    return;
  }

  late List<LineSeries<Point, double>> _dataset;
  late final StreamController<List<LineSeries<Point, double>>> _controller;
  late final StreamSubscription<void> _subscription;

  @override
  Stream<List<LineSeries<Point, double>>> get onUpdate => _controller.stream;

  @override
  void update(List<LineSeries<Point, double>> dataset) {
    _dataset = dataset;
    _controller.add(dataset);
  }

  @override
  int? index;

  final StreamController<LineChartTouchEvent> _onTouchEvent = StreamController.broadcast();
  @override
  Stream<LineChartTouchEvent> get onTouchEvent => _onTouchEvent.stream;
  @override
  bool isTouched = false;

  @override
  State<SyncfusionLineChart> createState() => _LineChartImplSyncfusionState();

  final ChartAxis? primaryYAxis;
  final TrackballBehavior? trackballBehavior;
  final ZoomPanBehavior? zoomPanBehavior;
}

class _LineChartImplSyncfusionState<View extends SyncfusionLineChart> extends State<View> {
  TrackballBehavior? get trackballBehavior => widget.trackballBehavior;
  ZoomPanBehavior? get zoomPanBehavior => widget.zoomPanBehavior;

  List<LineSeries<Point, double>> get dataset => widget._dataset;

  ChartAxis? get primaryYAxis => widget.primaryYAxis;

  bool get isTouched => widget.isTouched;
  setIsTouched(bool isTouched) {
    widget.isTouched = isTouched;
  }

  int? get index => widget.index;
  setIndex(int? index) {
    widget.index = index;
  }

  late final Widget view;

  void _update() {
    view = SfCartesianChart(
      series: dataset,
      trackballBehavior: trackballBehavior,
      zoomPanBehavior: zoomPanBehavior,
      onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
        setIsTouched(true);
        widget._onTouchEvent.add(LineChartTouchEvent(type: LineChartTouchEventType.down, index: index));
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
        setIsTouched(false);
        widget._onTouchEvent.add(LineChartTouchEvent(type: LineChartTouchEventType.up, index: index));
      },
      onTrackballPositionChanging: (TrackballArgs trackballArgs) {
        int? index = trackballArgs
            .chartPointInfo
            .dataPointIndex;
        setIndex(index);
        widget._onTouchEvent.add(LineChartTouchEvent(type: LineChartTouchEventType.move, index: index));
      },
      primaryYAxis: primaryYAxis,
    );
    return;
  }

  @override
  void initState() {
    super.initState();
    widget._subscription = widget._controller.stream.listen((data) => setState(() {
      _update();
    }));
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return view;
  }

  @override
  void dispose() {
    super.dispose();
    widget._subscription.cancel();
    widget._controller.close();
    return;
  }
}
