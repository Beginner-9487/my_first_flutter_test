import 'dart:math';

import 'package:flutter_utility/point_calculator.dart';

class PointCalculatorImpl implements PointCalculator {
  static PointCalculatorImpl? _instance;
  static PointCalculatorImpl getInstance() {
    _instance ??= PointCalculatorImpl._();
    return _instance!;
  }
  PointCalculatorImpl._();

  @override
  Iterable<Point<double>> mirrorPoints(Iterable<Point<double>> points, (Point<double>, Point<double>) line) {
    double a = (line.$1.y - line.$2.y);
    double b = - (line.$1.x - line.$2.x);
    double c = (line.$1.x * line.$2.y) - (line.$2.x * line.$1.y);
    return points
        .map((e) => (-2 * (a * e.x + b * e.y + c) / (a * a + b * b), e))
        .map((e) => Point(
          e.$1 * a + e.$2.x,
          e.$1 * b + e.$2.y,
        ));
  }

  @override
  Iterable<Point<double>> pointsRelativeToTheLastPoint(Iterable<Point<double>> points) {
    if(points.isEmpty) {
      return Iterable.generate(0);
    }
    List<Point<double>> array = [points.first];
    points.skip(1).forEach((element) {
      array.add(Point(
          element.x + array.last.x,
          element.y + array.last.y,
      ));
    });
    return array;
  }

  @override
  Iterable<Iterable<Point<double>>> fillTwoSidePoints(Iterable<Iterable<Point<double>>> pointsList) {
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