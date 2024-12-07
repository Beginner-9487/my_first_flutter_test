import 'dart:math';

abstract class PointCalculator {
  Iterable<Point<double>> pointsRelativeToTheLastPoint(Iterable<Point<double>> points);
  Iterable<Point<double>> mirrorPoints(Iterable<Point<double>> points, (Point<double> p1, Point<double> p2) line);
  Iterable<Iterable<Point<double>>> fillTwoSidePoints(Iterable<Iterable<Point<double>>> pointsList);
}