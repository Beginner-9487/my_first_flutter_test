import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/resources/global_variable.dart';

class HandToLineChart {
  static HandRepository get _handRepository => GlobalVariables.handRepository;

  static Iterable<Iterable<Point<double>>> _rowsToLineChartData(Iterable<HandRow> rows) {
    return Iterable.generate(6, (int index) {
      switch(index) {
        case 0:
          return rows.map((e) => Point(e.time, e.x0));
        case 1:
          return rows.map((e) => Point(e.time, e.y0));
        case 2:
          return rows.map((e) => Point(e.time, e.z0));
        case 3:
          return rows.map((e) => Point(e.time, e.x1));
        case 4:
          return rows.map((e) => Point(e.time, e.y1));
        case 5:
          return rows.map((e) => Point(e.time, e.z1));
        default:
          throw Exception();
      }
    });
  }

  static List<String> nameList = [
    "x0",
    "y0",
    "z0",
    "x1",
    "y1",
    "z1",
  ];

  static Iterable<LineSeries<Point, double>> get left {
    return _rowsToLineChartData(_handRepository.leftHandRows)
      .indexed
      .map((e) => LineSeries<Point, double>(
        dataSource: e.$2.toList(),
        animationDuration: 0,
        xValueMapper: (Point data, _) => data.x.toDouble(),
        yValueMapper: (Point data, _) => data.y.toDouble(),
        name: nameList[e.$1],
        width: 3,
      ));
  }

  static Iterable<LineSeries<Point, double>> get right {
    return _rowsToLineChartData(_handRepository.rightHandRows)
      .indexed
      .map((e) => LineSeries<Point, double>(
          dataSource: e.$2.toList(),
          animationDuration: 0,
          xValueMapper: (Point data, _) => data.x.toDouble(),
          yValueMapper: (Point data, _) => data.y.toDouble(),
          name: nameList[e.$1],
          width: 3,
      ));
  }
}