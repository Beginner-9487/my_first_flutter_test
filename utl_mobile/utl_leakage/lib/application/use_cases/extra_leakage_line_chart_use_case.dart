import 'dart:math';

import 'package:flutter_r/r.dart';
import 'package:utl_leakage/application/domain/leakage_repository.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';

class ExtraLeakageLineChartUseCase extends LineChartUseCaseImpl {
  LeakageRepository leakageRepository;
  ExtraLeakageLineChartUseCase(this.leakageRepository);

  @override
  List<LineChartCurveRow> get curveRow => [
    LineChartCurveRow(
      name: R.str.extraLeakage,
      points: leakageRepository
          .rows
          .map((e) => Point(e.time, e.extraVoltage))
          .toList(),
    ),
    LineChartCurveRow(
      name: R.str.extraLeakage,
      points: leakageRepository
          .rows
          .map((e) => Point(e.time, LeakageRepository.EXTRA_LEAKAGE_WARNING_VOLTAGE))
          .toList(),
    ),
  ];

  @override
  List<LineChartDashboardRow> get dashBoardRows => throw UnimplementedError();
}