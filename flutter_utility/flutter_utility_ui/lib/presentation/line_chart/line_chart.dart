import 'dart:async';

import 'package:flutter/material.dart';

abstract class LineChart<Dataset> extends StatefulWidget {
  const LineChart({super.key});
  void update(Dataset dataset);
  bool get isTouched;
  int? get index;
  Stream<Dataset> get onUpdate;
  Stream<LineChartTouchEvent> get onTouchEvent;
}

class LineChartTouchEvent {
  int? index;
  LineChartTouchEventType type;
  LineChartTouchEvent({
    this.index,
    required this.type,
  });
}

enum LineChartTouchEventType {
  down,
  up,
  move,
}
