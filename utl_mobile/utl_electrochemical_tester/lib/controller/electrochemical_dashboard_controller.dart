import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ElectrochemicalLineChartMode {
  ampereIndex,
  ampereTime,
  ampereVolt,
}

abstract class LineChartSeriesListChangeNotifier extends ChangeNotifier {
  List<LineSeries<Point<num>, double>> get seriesList;
}

abstract class LineChartInfoChangeNotifier extends ChangeNotifier {
  List<ElectrochemicalLineChartInfoDto> get info;
  ElectrochemicalLineChartMode get mode;
}

abstract class LineChartDatasetModeChangeNotifier extends ChangeNotifier {
  ElectrochemicalLineChartMode get mode;
}

abstract class LineChartDatasetTypesShowChangeNotifier extends ChangeNotifier {
  Map<ElectrochemicalType, bool> get shows;
}

abstract class ElectrochemicalLineChartController {
  LineChartSeriesListChangeNotifier get lineChartSeriesListChangeNotifier;
  set x(double? x);
}

abstract class ElectrochemicalLineChartInfoController {
  LineChartInfoChangeNotifier get lineChartInfoChangeNotifier;
}

abstract class ElectrochemicalLineChartSetterController {
  LineChartDatasetModeChangeNotifier get lineChartMode;
  set mode(ElectrochemicalLineChartMode mode);
  LineChartDatasetTypesShowChangeNotifier get lineChartTypesShow;
  void setTypeShow({
    required ElectrochemicalType type,
    required bool show,
  });
}

abstract class ElectrochemicalFeatureController {
  Future<bool> downloadFile({
    required AppLocalizations appLocalizations,
  });
  Future<bool> clearRepository();
}
