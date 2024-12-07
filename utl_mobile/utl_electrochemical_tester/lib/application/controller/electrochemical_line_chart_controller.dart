import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_utility/other_utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data_listener.dart';

abstract class Electrochemical_Line_Chart_Controller {
  StreamSubscription<void> onDataUpdate(void Function(void) onDataUpdate);

  List<LineSeries<Point<num>, double>> get line_chart_data;
  void setLineChartTouchedIndex(int? index);

  Iterable<ElectrochemicalDashboardData> get dashboard_data;
  StreamSubscription<int?> onLineChartTouchedIndexChange(void Function(int? index) onLineChartTouchedIndexChange);
}

class Electrochemical_Line_Chart_Controller_Impl implements Electrochemical_Line_Chart_Controller {
  Electrochemical_Line_Chart_Controller_Impl({
    required this.contextResource,
    required this.electrochemical_data_listener,
  }) {
    _onUpdate = electrochemical_data_listener.on_UI_data_update((entity) {
      _onDataUpdateController.add(null);
    });
    _onFinish = electrochemical_data_listener.on_UI_data_finish((entity) {
      _onDataUpdateController.add(null);
    });
  }
  final ContextResource contextResource;
  final Electrochemical_Data_Listener electrochemical_data_listener;
  Iterable<Electrochemical_UI_Data> get UI_data => electrochemical_data_listener.UI_data;
  final StreamController<void> _onDataUpdateController = StreamController.broadcast();
  final StreamController<_IntN> _onLineChartTouchedIndexChangeController = StreamController.broadcast();
  late final StreamSubscription<Electrochemical_UI_Data> _onUpdate;
  late final StreamSubscription<Electrochemical_UI_Data> _onFinish;

  final _IntN _intN = _IntN();
  int? get index => _intN.value;

  @override
  Iterable<ElectrochemicalDashboardData> get dashboard_data {
    if(index == null) {
      return const Iterable.empty();
    }
    List<ElectrochemicalDashboardData> list = [];
    for(var data in electrochemical_data_listener.UI_data) {
      if(data.points.skip(index!).firstOrNull == null) {
        continue;
      }
      list.add(ElectrochemicalDashboardData(
        name: data.data_name,
        color: data.color,
        created_time: data.created_time.toString(),
        type: data.typeString,
        temperature: data.temperature,
        index: index!,
        time_since_created: (data.points.skip(index!).first.time_since_created.inMicroseconds / 1000000).toString(),
        current: data.points.skip(index!).map((e) => e.current).first,
        voltage: data.points.skip(index!).map((e) => e.voltage).first,
      ));
    }
    return list;
  }

  @override
  List<LineSeries<Point<num>, double>> get line_chart_data => UI_data
      .map((entity) => LineSeries<Point, double>(
          name: entity.data_name,
          dataSource: entity
              .points
              .map((e) => Point((e.time_since_created.inMicroseconds / 1000000).toPrecision(4), e.current))
              .toList(),
          animationDuration: 0,
          xValueMapper: (Point data, _) => data.x.toDouble(),
          yValueMapper: (Point data, _) => data.y.toDouble(),
          color: entity.color,
          width: 1.5,
      )
  ).toList();

  @override
  StreamSubscription<void> onDataUpdate(void Function(void p1) onDataUpdate) {
    return _onDataUpdateController.stream.listen(onDataUpdate);
  }

  @override
  StreamSubscription<int?> onLineChartTouchedIndexChange(void Function(int? index) onLineChartTouchedIndexChange) {
    return _onLineChartTouchedIndexChangeController
        .stream
        .map((event) => event.value)
        .listen(onLineChartTouchedIndexChange);
  }

  @override
  void setLineChartTouchedIndex(int? index) {
    _intN.value = index;
    _onLineChartTouchedIndexChangeController.add(_intN);
  }

}

class _IntN {
  int? value;
}

class ElectrochemicalDashboardData {
  ElectrochemicalDashboardData({
    required this.name,
    required this.color,
    required this.created_time,
    required this.type,
    required this.temperature,
    required this.index,
    required this.time_since_created,
    required this.current,
    required this.voltage,
  });
  String name;
  Color color;
  String created_time;
  String type;
  double temperature;
  int index;
  String time_since_created;
  double current;
  double voltage;
}