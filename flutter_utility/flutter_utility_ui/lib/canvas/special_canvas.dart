import 'dart:math';
import 'dart:ui';

abstract class SpecialCanvas {
  void drawArrow(
    Canvas canvas,
    Paint paint,
    Point<double> center,
    double length,
    double radians,
  );
}