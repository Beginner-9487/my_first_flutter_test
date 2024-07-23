import 'dart:ui';

import 'package:flutter/material.dart';

class DataColor {
  DataColor._();

  static Color dataColorGeneratorGrayscale({
    required double alpha,
    required int dataIndex,
    required int dataSize,
  }) {
    return HSVColor.fromAHSV(
        alpha,
        (dataSize>0) ? (255.0 * dataIndex/dataSize) : 0,
        0.0,
        1.0,
    ).toColor();
  }

  static Color dataColorGeneratorRainbow({
    required double alpha,
    required int dataIndex,
    required int dataSize,
  }) {
    return HSVColor.fromAHSV(
        alpha,
        (dataSize > 0) ? (255.0 * dataIndex / dataSize) : 0,
        1.0,
        1.0,
    ).toColor();
  }

  static Color dataColorGeneratorRainbowLayer({
    required double alpha,
    required int dataIndex,
    required int dataSize,
    required int layerIndex,
    required int layerSize,
  }) {
    return HSVColor.fromAHSV(
        alpha,
        (layerSize > 0) ? (255.0 * layerIndex / layerSize) : 0,
        1.0,
        (dataSize > 0) ? (1.0 * dataIndex / dataSize) : 1.0
    ).toColor();
  }
}