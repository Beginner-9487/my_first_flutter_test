import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

abstract class Line_Chart extends StatefulWidget {
  const Line_Chart({super.key});
  void update(List<LineSeries<Point, double>> data);
  bool get isTouched;
  int? get index;
  StreamSubscription<TOUCH_EVENT> onTouchEvent(void Function(TOUCH_EVENT event) onTouchEvent);
}

enum TOUCH_EVENT {
  TOUCH_DOWN,
  TOUCH_UP,
  TOUCH_MOVE,
}