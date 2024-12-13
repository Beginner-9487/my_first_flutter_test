import 'dart:math';
import 'dart:ui';

import 'package:flutter_utility/geometry_utils.dart';

extension SpecialPath on Path {
  /// Creates an arrow-shaped path with specified properties.
  static Path arrow({
    required Point<double> center,
    required double length,
    required double radians,
  }) {
    final path = Path();

    // Pre-computed constants
    final bodyLength = length * 0.6; // Length of the arrow body
    final headLength = length - bodyLength; // Length of the arrow head
    final width = length * 0.3; // Total width of the arrow
    final halfWidth = width / 2;
    final eaves = width / 4;

    // Calculate the peak of the arrowhead
    final Point<double> peak = Point(
      center.x + length * cos(radians),
      center.y + length * sin(radians),
    );

    // Calculate the base points of the arrow
    final Iterable<Point<double>> points = GeometryUtils.calculateRelativePoints(
      points: [
        center,
        Point(
          halfWidth * cos(radians - (pi / 2)),
          halfWidth * sin(radians - (pi / 2)),
        ),
        Point(
          bodyLength * cos(radians),
          bodyLength * sin(radians),
        ),
        Point(
          eaves * cos(radians - (pi / 2)),
          eaves * sin(radians - (pi / 2)),
        ),
      ],
    ).skip(1);

    // Generate mirrored points for the other half of the arrow
    final Iterable<Point<double>> mirrorPoints = GeometryUtils.calculateMirrorPoints(
      points: points,
      line: Line.fromPoints(center, peak),
    );

    // Construct the path
    path
      ..moveTo(center.x, center.y)
      ..addPolygon(
        points.map((p) => Offset(p.x, p.y)).toList(),
        false,
      )
      ..lineTo(peak.x, peak.y)
      ..addPolygon(
        mirrorPoints.toList().reversed.map((p) => Offset(p.x, p.y)).toList(),
        false,
      )
      ..close();

    return path;
  }
}
