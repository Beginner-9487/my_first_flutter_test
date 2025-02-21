import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/controller/dto/amulet_line_chatr.dto.dart';
import 'package:utl_amulet/controller/dto/controller_dto_mapper.dart';

// enum AmuletLineChartMode {
//   acc,
//   mag,
//   pry,
//   pressure,
//   temperature,
//   posture,
//   battery,
//   area,
//   step,
//   direction,
// }

abstract class AmuletLineChartSeriesListChangeNotifier extends ChangeNotifier {
  List<LineSeries<Point<num>, double>> get seriesList;
}

abstract class AmuletLineChartInfoChangeNotifier extends ChangeNotifier {
  AmuletLineChartInfoDto? get info;
  double? get x;
  String getXLabel({
    required AppLocalizations appLocalizations,
  });
  String getXData();
  String getYLabel({
    required AppLocalizations appLocalizations,
    required AmuletLineChartItem item,
  });
  String getYData({
    required AmuletLineChartItem item,
  });
}

// abstract class AmuletLineChartModeChangeNotifier extends ChangeNotifier {
//   Map<AmuletLineChartMode, bool> get mode;
// }

abstract class AmuletLineChartController {
  AmuletLineChartSeriesListChangeNotifier createSeriesListChangeNotifier({
    required AppLocalizations appLocalizations,
  });
  bool get isTouched;
  set isTouched(bool isTouched);
  set x(double? x);
}

abstract class AmuletLineChartInfoController {
  AmuletLineChartInfoChangeNotifier createInfoChangeNotifier();
}
