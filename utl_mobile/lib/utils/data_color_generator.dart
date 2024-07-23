import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class DataColorGenerator {
  static Color grayscale({
    required double alpha,
    required int dataIndex,
    required int dataSize,
  }) {
    return HSVColor.fromAHSV(
      alpha,
      0.0,
      0.0,
      (dataSize>0) ? ((dataSize < 255.0) ? (255.0 * dataIndex/dataSize) : 255.0) : 0,
    ).toColor();
  }

  static Color rainbow({
    required double alpha,
    required int dataIndex,
    required int dataSize,
  }) {
    return HSVColor.fromAHSV(
      alpha,
      (dataSize > 0) ? ((dataSize < 255.0) ? (255.0 * dataIndex/dataSize) : 255.0) : 0,
      1.0,
      1.0,
    ).toColor();
  }

  static Color rainbowLayer({
    required double alpha,
    required int currentLayerDataIndex,
    required int currentLayerDataSize,
    required int layerIndex,
    required int layerSize,
  }) {
    return HSVColor.fromAHSV(
        alpha,
        (layerSize > 0) ? ((layerSize < 255.0) ? (255.0 * layerIndex/layerSize) : 255.0) : 0,
        1.0,
        (currentLayerDataSize > 0) ? min(1.0 * currentLayerDataIndex / currentLayerDataSize, 1.0) : 1.0
    ).toColor();
  }
}