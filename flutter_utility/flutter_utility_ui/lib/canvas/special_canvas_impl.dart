import 'dart:math';
import 'dart:ui';

import 'package:flutter_utility/point_calculator.dart';
import 'package:flutter_utility/point_calculator_impl.dart';
import 'package:flutter_utility_ui/canvas/special_canvas.dart';

class SpecialCanvasImpl implements SpecialCanvas {
  static SpecialCanvasImpl? _instance;
  static SpecialCanvasImpl getInstance() {
    _instance ??= SpecialCanvasImpl._();
    return _instance!;
  }
  SpecialCanvasImpl._();

  @override
  void drawArrow(
      Canvas canvas,
      Paint paint,
      Point<double> center,
      double length,
      double radians,
      ) {
    final path = Path();
    final body = length * 0.6;
    final head = length - body;
    final width = length * 0.3;
    final widthHalf = width / 2;
    final eaves = width / 4;

    Point<double> peak = Point(
      center.x + length * cos(radians),
      center.y + length * sin(radians),
    );

    PointCalculator p = PointCalculatorImpl.getInstance();
    Iterable<Point<double>> points = p
        .pointsRelativeToTheLastPoint([
          center,
          Point(
            widthHalf * cos(radians - (pi / 2)),
            widthHalf * sin(radians - (pi / 2)),
          ),
          Point(
            body * cos(radians),
            body * sin(radians),
          ),
          Point(
            eaves * cos(radians - (pi / 2)),
            eaves * sin(radians - (pi / 2)),
          ),
        ])
        .skip(1);
    Iterable<Point<double>> mirrorPoints = p.mirrorPoints(points, (center, peak));

    path.moveTo(center.x, center.y);
    for (var element in points) {
      path.lineTo(element.x, element.y);
    }
    path.lineTo(peak.x, peak.y);
    for (var element in mirrorPoints.toList().reversed) {
      path.lineTo(element.x, element.y);
    }
    path.lineTo(center.x, center.y);

    canvas.drawPath(path, paint);
  }
}