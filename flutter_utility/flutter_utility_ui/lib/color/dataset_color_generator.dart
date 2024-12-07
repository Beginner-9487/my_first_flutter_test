import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class DatasetColorGenerator {
  Color grayscale({
    required double alpha,
    required int index,
    required int length,
  });

  Color rainbow({
    required double alpha,
    required int index,
    required int length,
  });

  Color rainbowLayer({
    required double alpha,
    required int index,
    required int length,
    required int arrayIndex,
    required int arrayLength,
  });
}