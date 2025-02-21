import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

enum ElectrochemicalLineChartMode {
  ampereIndex,
  ampereTime,
  ampereVolt,
}

abstract class LineChartSeriesListChangeNotifier extends ChangeNotifier {
  List<LineSeries<Point<num>, double>> get seriesList;
}

abstract class LineChartInfoListChangeNotifier extends ChangeNotifier {
  List<ElectrochemicalLineChartInfoDto> get infoList;
}

abstract class LineChartXChangeNotifier extends ChangeNotifier {
  double? get x;
}

abstract class LineChartModeChangeNotifier extends ChangeNotifier {
  ElectrochemicalLineChartMode get mode;
}

abstract class LineChartTypesShowChangeNotifier extends ChangeNotifier {
  Map<ElectrochemicalType, bool> get shows;
}

abstract class ElectrochemicalLineChartController {
  LineChartSeriesListChangeNotifier createLineChartSeriesListChangeNotifier(BuildContext context);
  set x(double? x);
}

abstract class ElectrochemicalLineChartInfoController {
  LineChartInfoListChangeNotifier createLineChartInfoListChangeNotifier(BuildContext context);
  LineChartModeChangeNotifier createLineChartModeChangeNotifier(BuildContext context);
  LineChartXChangeNotifier createLineChartXChangeNotifier(BuildContext context);
  // void renameInfo({
  //   required ElectrochemicalLineChartInfoDto info,
  //   required String newName,
  // });
  // void deleteInfo({
  //   required ElectrochemicalLineChartInfoDto info,
  // });
}

abstract class ElectrochemicalLineChartSetterController {
  LineChartModeChangeNotifier createLineChartModeChangeNotifier(BuildContext context);
  set mode(ElectrochemicalLineChartMode mode);
  LineChartTypesShowChangeNotifier createLineChartTypesShowChangeNotifier(BuildContext context);
  void setTypeShow({
    required ElectrochemicalType type,
    required bool show,
  });
}
