import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_utility_ui/color/dataset_color_generator.dart';

class DatasetColorGeneratorImpl implements DatasetColorGenerator {
  static double _range(double start, double value, double end) {
    return max(min(value, end),start);
  }

  @override
  Color grayscale({
    required double alpha,
    required int index,
    required int length,
  }) {
    return HSVColor.fromAHSV(
      alpha,
      0.0,
      0.0,
      _range(0, 255.0 * index/length, 255.0),
    ).toColor();
  }

  @override
  Color rainbow({
    required double alpha,
    required int index,
    required int length,
  }) {
    return HSVColor.fromAHSV(
      alpha,
      _range(0, 255.0 * index/length, 255.0),
      1.0,
      1.0,
    ).toColor();
  }

  @override
  Color rainbowLayer({
    required double alpha,
    required int index,
    required int length,
    required int arrayIndex,
    required int arrayLength,
  }) {
    return HSVColor.fromAHSV(
      alpha,
      _range(0, 255.0 * arrayIndex/arrayLength, 255.0),
      1.0,
      _range(0, 1.0 * index/length, 1.0),
    ).toColor();
  }
}