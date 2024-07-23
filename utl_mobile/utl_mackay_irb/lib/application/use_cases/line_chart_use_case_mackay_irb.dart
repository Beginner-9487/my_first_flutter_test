import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mobile/utils/data_color_generator.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';

class LineChartUseCaseMackayIRB extends LineChartUseCaseImpl {
  final MackayIRBRepository _repository;
  LineChartUseCaseMackayIRB(this._repository);

  StreamSubscription<MackayIRBRow> onRepositoryUpdated(void Function(MackayIRBRow row) doSomething) {
    return _repository.onNewRowAdded(doSomething);
  }

  Color getColor(int indexRow, int type) {
    return DataColorGenerator.rainbowLayer(
      alpha: 0.75,
      currentLayerDataIndex: indexRow + 10,
      currentLayerDataSize: _repository.entities
          .where((element) => element.type == type)
          .length + 10,
      layerIndex: type,
      layerSize: 6,
    );
  }

  @override
  List<LineChartCurveRow> get curveRow {
    return _repository.entities
        .indexed
        .map((e) => LineChartCurveRow(
            name: e.$2.name,
            color: getColor(e.$1, e.$2.type),
            points: e.$2.rows
                .map((e) => Point(e.voltage, e.current))
                .toList(),
        ))
        .toList();
  }

  @override
  List<LineChartDashboardRow> get dashBoardRows {
    return _repository.entities
        .indexed
        .map((e) => LineChartDashboardRow(
            name: e.$2.name,
            points: e.$2.rows.map((e) => Point(e.voltage, e.current)).toList(),
            xLabelName: R.str.voltage,
            yLabelName: R.str.current,
            xUnitName: "mV",
            yUnitName: "uA",
            color: getColor(e.$1, e.$2.type),
        ))
        .toList();
  }
}