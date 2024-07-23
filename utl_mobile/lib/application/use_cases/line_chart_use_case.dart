import 'dart:math';
import 'dart:ui';

import 'package:syncfusion_flutter_charts/charts.dart';

abstract class LineChartUseCase {
  (List<ChartSeriesController>, List<LineSeries<Point, double>>) get chartData;
  Iterable<LineChartCurveRow> get curveRow;
  List<LineChartDashboardRow> get dashBoardRows;
}

abstract class LineChartUseCaseImpl implements LineChartUseCase {
  @override
  (List<ChartSeriesController>, List<LineSeries<Point, double>>) get chartData {
    List<ChartSeriesController> controllers = [];
    List<LineSeries<Point, double>> data = curveRow.map((e) => LineSeries<Point, double>(
      dataSource: e.points.toList(),
      animationDuration: 0,
      xValueMapper: (Point data, _) => data.x.toDouble(),
      yValueMapper: (Point data, _) => data.y.toDouble(),
      color: e.color,
      name: e.name,
      width: 0.5,
      onRendererCreated: (ChartSeriesController controller) {
        controllers.add(controller);
      }
    ))
    .toList();
    return (controllers, data);
  }

  List<List<Point<double>>> fillTwoSidePoints(Iterable<Iterable<Point<double>>> pointsList) {
    /// Get minX and maxX.
    double? minX;
    double? maxX;
    for(var points in pointsList) {
      if(points.isEmpty) {
        continue;
      }
      minX = (minX == null || minX > points.first.x) ? points.first.x : minX;
      maxX = (maxX == null || maxX < points.last.x) ? points.last.x : maxX;
    }

    List<List<Point<double>>> finalList = pointsList.map((e) => e.toList()).toList();
    if(minX == null || maxX == null) {
      return finalList;
    }

    /// Use minX and maxX to make line chart look better.
    for(var points in finalList) {
      if(points.isEmpty) {
        continue;
      }
      if(points.first.x != minX) {
        points
            .insert(0, Point(minX, points.first.y));
      }
      if(points.last.x != maxX) {
        points
            .add(Point(maxX, points.last.y));
      }
    }
    return finalList;
  }
}

class LineChartCurveRow {
  String name;
  Color? color;
  List<Point> points;
  LineChartCurveRow({
    required this.name,
    this.color,
    required this.points,
  });
}

class LineChartDashboardRow {
  String name;
  String xLabelName;
  String yLabelName;
  String xUnitName;
  String yUnitName;
  Color? color;
  List<Point> points;
  LineChartDashboardRow({
    required this.name,
    required this.points,
    required this.xLabelName,
    required this.yLabelName,
    required this.xUnitName,
    required this.yUnitName,
    this.color,
  });
}