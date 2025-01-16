import 'dart:math';

/// Represents a line defined by two points or other mathematical properties.
class Line {
  final Point<double> start;
  final Point<double> end;

  /// Private constructor to enforce controlled creation through factory methods.
  const Line._(this.start, this.end);

  /// Creates a line from two points.
  factory Line.fromPoints(Point<double> start, Point<double> end) {
    return Line._(start, end);
  }

  /// Creates a line from slope and y-intercept.
  ///
  /// - [slope]: The slope of the line.
  /// - [yIntercept]: The y-intercept of the line (where it crosses the y-axis).
  factory Line.fromSlopeAndIntercept(double slope, double yIntercept, double rangeStart, double rangeEnd) {
    final start = Point<double>(rangeStart, slope * rangeStart + yIntercept);
    final end = Point<double>(rangeEnd, slope * rangeEnd + yIntercept);
    return Line._(start, end);
  }

  /// Creates a vertical line with a constant x-coordinate.
  factory Line.vertical(double x, double rangeStart, double rangeEnd) {
    return Line._(
      Point<double>(x, rangeStart),
      Point<double>(x, rangeEnd),
    );
  }

  /// Creates a horizontal line with a constant y-coordinate.
  factory Line.horizontal(double y, double rangeStart, double rangeEnd) {
    return Line._(
      Point<double>(rangeStart, y),
      Point<double>(rangeEnd, y),
    );
  }

  /// Creates a line from a string equation in the form "y = mx + b".
  ///
  /// Example input: "y = 2x + 3"
  factory Line.fromEquation(String equation, double rangeStart, double rangeEnd) {
    final match = RegExp(r'y\s*=\s*([+-]?\d*\.?\d*)x\s*([+-]\s*\d+\.?\d*)')
        .firstMatch(equation.replaceAll(' ', ''));

    if (match == null) {
      throw ArgumentError('Invalid equation format. Expected "y = mx + b".');
    }

    final slope = double.tryParse(match.group(1) ?? '1') ?? 1;
    final intercept = double.tryParse(match.group(2)!.replaceAll(' ', '')) ?? 0;

    return Line.fromSlopeAndIntercept(slope, intercept, rangeStart, rangeEnd);
  }

  factory Line.fromCenter({
    required Point<double> center,
    required double length,
    required double radians,
  }) {
    return Line._(
      center,
      Point<double>(
        center.x + (length * cos(radians)),
        center.y + (length * sin(radians)),
      ),
    );
  }

  @override
  String toString() => 'Line(start: $start, end: $end)';
}


/// Geometry utilities class for point transformations and calculations.
class GeometryUtils {
  GeometryUtils._();

  /// Calculates the mirror points of a given set of points relative to a specified line.
  ///
  /// - [points]: The set of points to be mirrored.
  /// - [line]: The line relative to which the points are mirrored.
  /// Returns: An iterable containing the mirrored points.
  static Iterable<Point<double>> calculateMirrorPoints({
    required Iterable<Point<double>> points,
    required Line line,
  }) {
    final double a = line.start.y - line.end.y;
    final double b = -(line.start.x - line.end.x);
    final double c = line.start.x * line.end.y - line.end.x * line.start.y;

    final double denominator = a * a + b * b;

    return points.map((point) {
      final double factor = -2 * (a * point.x + b * point.y + c) / denominator;
      return Point(
        factor * a + point.x,
        factor * b + point.y,
      );
    });
  }

  /// Calculates the cumulative positions of a sequence of points.
  ///
  /// - [points]: The collection of points to calculate cumulative positions for.
  /// Returns: A new collection of points where each point's position is the cumulative
  ///          sum relative to the previous points.
  static Iterable<Point<T>> calculateCumulativePositions<T extends num>({
    required Iterable<Point<T>> points,
  }) sync* {
    if (points.isEmpty) return;
    var cumulativePoint = Point<T>(0 as T, 0 as T);
    for (final point in points) {
      cumulativePoint = Point(
        (cumulativePoint.x + point.x) as T,
        (cumulativePoint.y + point.y) as T,
      );
      yield cumulativePoint;
    }
  }

}
