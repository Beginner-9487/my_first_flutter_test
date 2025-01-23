import 'package:flutter/cupertino.dart';

class LineChartInfoController extends ValueNotifier<double?> {
  LineChartInfoController({
    double? x,
  }) : super(x);
  set x(double? x) => super.value = x;
  double? get x => super.value;
}

abstract class LineChartInfoView extends StatefulWidget {
  const LineChartInfoView({
    super.key,
    this.lineChartInfoController,
  });
  final LineChartInfoController? lineChartInfoController;
}
