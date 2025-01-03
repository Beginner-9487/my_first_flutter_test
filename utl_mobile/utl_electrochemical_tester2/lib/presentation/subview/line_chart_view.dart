import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_utility/general_utils.dart';
import 'package:flutter_utility_ui/dataset_color_generator.dart';
import 'package:flutter_utility_ui/presentation/line_chart/syncfusion_line_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_type.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/service/electrochemical_data_service.dart';

enum LineChartMode {
  ampereTime,
  ampereVolt,
}

const LineChartMode _defaultMode = LineChartMode.ampereTime;

abstract class LineChart extends StatefulWidget {
  const LineChart({super.key});

  void setMode(LineChartMode mode);
  void cancel();
}

class ConcreteLineChart extends SyncfusionLineChart implements LineChart {
  ElectrochemicalDataService service;
  late final StreamSubscription<ElectrochemicalDataEntity> _onUpdate;
  ConcreteLineChart({
    super.key,
    super.primaryYAxis,
    required this.service,
  }) : super(
    trackballBehavior: TrackballBehavior(
      enable: true,
      shouldAlwaysShow: true,
      activationMode: ActivationMode.singleTap,
      tooltipAlignment: ChartAlignment.near,
      tooltipDisplayMode: TrackballDisplayMode.none,
    ),
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      // enableDoubleTapZooming: true,
      enablePanning: true,
      // zoomMode: ZoomMode.x,
      enableMouseWheelZooming: true,
    ),
  ) {
    _onUpdate = service.onUpdate.listen((data) => update(dataset));
  }
  LineChartMode _mode = _defaultMode;
  List<LineSeries<Point<num>, double>> get dataset => service.latestEntities.indexed.map((entity) => LineSeries<Point, double>(
    name: entity.$2.dataName,
    dataSource: entity.$2.data.map((e) {
      switch(_mode) {
        case LineChartMode.ampereTime:
          return Point(
            (e.time / 1E6).toPrecision(4),
            (e.current / 1E6).toPrecision(4),
          );
        case LineChartMode.ampereVolt:
          return Point(
            (e.voltage / 1E6).toPrecision(4),
            (e.current / 1E6).toPrecision(4),
          );
      }
    }).toList(),
    animationDuration: 0,
    xValueMapper: (Point data, _) => data.x.toDouble(),
    yValueMapper: (Point data, _) => data.y.toDouble(),
    color: DatasetColorGenerator.rainbowGroup(
      alpha: 1,
      index: entity.$1,
      length: service.latestEntities.length,
      groupIndex: ElectrochemicalType.values.indexOf(entity.$2.type),
      groupLength: ElectrochemicalType.values.length,
    ),
    width: 1.5,
  )).toList();
  @override
  void setMode(LineChartMode mode) {
    _mode = mode;
    update(dataset);
  }
  @override
  void cancel() {
    _onUpdate.cancel();
  }
}
