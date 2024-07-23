import 'dart:math';

import 'package:flutter_r/r.dart';
import 'package:utl_leakage/application/domain/leakage_repository.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';

class IntraOsmosisLineChartUseCase extends LineChartUseCaseImpl {
  LeakageRepository leakageRepository;
  IntraOsmosisLineChartUseCase(this.leakageRepository);

  @override
  List<LineChartCurveRow> get curveRow => [
    LineChartCurveRow(
      name: R.str.intraOsmosis,
      points: leakageRepository
          .rows
          .map((e) => Point(e.time, e.intraCapacitance))
          .toList(),
    ),
    LineChartCurveRow(
      name: R.str.intraOsmosis,
      points: leakageRepository
          .rows
          .map((e) => Point(e.time, LeakageRepository.INTRA_LEAKAGE_WARNING_CAPACITANCE))
          .toList(),
    ),
  ];

  @override
  List<LineChartDashboardRow> get dashBoardRows => throw UnimplementedError();
}