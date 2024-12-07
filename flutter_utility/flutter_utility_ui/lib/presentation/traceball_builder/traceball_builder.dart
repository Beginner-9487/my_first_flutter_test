import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';

abstract class TraceBallBuilder {
  setData(List<LineSeries<Point, double>> data);
  setIndex(int? index);
}

abstract class TraceBallBuilderBase implements TraceBallBuilder {
  List<LineSeries<Point, double>> data = [];
  int? lastSelectedXIndex;
  @override
  setData(List<LineSeries<Point, double>> data) {
    this.data = data;
  }
  @override
  setIndex(int? index) {
    lastSelectedXIndex = index;
  }
}