import 'dart:math';
import 'dart:ui';

class SpecialCanvas {
  static drawArrow(
    Canvas canvas,
    Paint paint,
    Point<double> center,
    double length,
    double radians,
    {
      double? width,
    }
  ) {
    if(length == 0) {
      return;
    }

    final path = Path();
    final body = length * 0.6;
    final head = length - body;
    width ??= length * 0.3;
    final widthHalf = width / 2;
    final eaves = width / 4;

    _PointRecorder p = _PointRecorder(center);
    path.moveTo(p.x, p.y);
    p.addFromLastPoint(Point(
        widthHalf * cos(radians - (pi / 2)),
        widthHalf * sin(radians - (pi / 2)),
    ));
    path.lineTo(p.x, p.y);
    p.addFromLastPoint(Point(
      body * cos(radians),
      body * sin(radians),
    ));
    path.lineTo(p.x, p.y);
    p.addFromLastPoint(Point(
      eaves * cos(radians - (pi / 2)),
      eaves * sin(radians - (pi / 2)),
    ));
    path.lineTo(p.x, p.y);
    p.setCurrentPoint(Point(
      center.x + length * cos(radians),
      center.y + length * sin(radians),
    ));

    Iterator<Point<double>> mirrorPoints = p.mirrorPoints.reversed.iterator;
    mirrorPoints.moveNext();
    path.lineTo(mirrorPoints.current.x, mirrorPoints.current.y);
    mirrorPoints.moveNext();
    path.lineTo(mirrorPoints.current.x, mirrorPoints.current.y);
    mirrorPoints.moveNext();
    path.lineTo(mirrorPoints.current.x, mirrorPoints.current.y);
    mirrorPoints.moveNext();
    path.lineTo(mirrorPoints.current.x, mirrorPoints.current.y);
    mirrorPoints.moveNext();
    path.lineTo(mirrorPoints.current.x, mirrorPoints.current.y);

    canvas.drawPath(path, paint);
  }
}

class _PointRecorder {
  final List<Point<double>> points = [];
  _PointRecorder(Point<double> point) {
    points.add(point);
  }
  double get x => points.last.x;
  double get y => points.last.y;
  setCurrentPoint(Point<double> point) {
    points.add(point);
  }
  addFromLastPoint(Point<double> point) {
    points.add(Point(point.x + x, point.y + y));
  }
  List<Point<double>> get mirrorPoints {
    double a = (points.first.y - points.last.y);
    double b = - (points.first.x - points.last.x);
    double c = (points.first.x * points.last.y) - (points.last.x * points.first.y);
    List<double> temp = points
        .map((e) => -2 * (a * e.x + b * e.y + c) / (a * a + b * b))
        .toList();
    return points
        .indexed
        .map((e) => Point(
            temp[e.$1] * a + e.$2.x,
            temp[e.$1] * b + e.$2.y,
        ))
        .toList();
  }
}