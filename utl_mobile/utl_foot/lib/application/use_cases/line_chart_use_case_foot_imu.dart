import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/resources/global_variables.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';
import 'package:utl_mobile/utils/dataset_color_generator.dart';

class LineChartUseCaseFootIMU extends LineChartUseCaseImpl {
  final GlobalVariables _globalVariables;
  FootRepository get _footRepository => _globalVariables.footRepository;
  LineChartUseCaseFootIMU(this._globalVariables);

  static const int _MAX_LENGTH = 10;
  static const int roundPosition = 100;

  Color _getColor(int itemIndex, int bodyPartIndex) {
    return DataColorGenerator.rainbowLayer(
      alpha: 1,
      currentLayerDataIndex: itemIndex + 10,
      currentLayerDataSize: 22,
      layerIndex: bodyPartIndex,
      layerSize: 2,
    );
  }

  Iterable<Color> bodyPartToColors(int bodyPart) {
    return Iterable.generate(12, (int n) {
      switch (bodyPart) {
        case BodyPart.LEFT_FOOT:
          return _getColor(n, 0);
        case BodyPart.RIGHT_FOOT:
          return _getColor(n, 1);
        default:
          throw Exception();
      }
    });
  }

  Iterable<String> bodyPartToListName(int bodyPart) {
    return Iterable.generate(12, (int n) {
      switch (n) {
        case 0:
          return "$bodyPart: ${R.str.accX}";
        case 1:
          return "$bodyPart: ${R.str.accY}";
        case 2:
          return "$bodyPart: ${R.str.accZ}";
        case 3:
          return "$bodyPart: ${R.str.gyroX}";
        case 4:
          return "$bodyPart: ${R.str.gyroY}";
        case 5:
          return "$bodyPart: ${R.str.gyroZ}";
        case 6:
          return "$bodyPart: ${R.str.magX}";
        case 7:
          return "$bodyPart: ${R.str.magY}";
        case 8:
          return "$bodyPart: ${R.str.magZ}";
        case 9:
          return "$bodyPart: ${R.str.pitch}";
        case 10:
          return "$bodyPart: ${R.str.roll}";
        case 11:
          return "$bodyPart: ${R.str.yaw}";
        default:
          throw Exception();
      }
    });
  }

  Iterable<Iterable<Point<double>>> footRowsToListPoints(Iterable<FootRow> rows) {
    return Iterable.generate(12, (int n) {
      switch (n) {
        case 0:
          return rows.map((e) => Point(e.time, (e.accX * roundPosition).round() / roundPosition));
        case 1:
          return rows.map((e) => Point(e.time, (e.accY * roundPosition).round() / roundPosition));
        case 2:
          return rows.map((e) => Point(e.time, (e.accZ * roundPosition).round() / roundPosition));
        case 3:
          return rows.map((e) => Point(e.time, (e.gyroX * roundPosition).round() / roundPosition));
        case 4:
          return rows.map((e) => Point(e.time, (e.gyroY * roundPosition).round() / roundPosition));
        case 5:
          return rows.map((e) => Point(e.time, (e.gyroZ * roundPosition).round() / roundPosition));
        case 6:
          return rows.map((e) => Point(e.time, (e.magX * roundPosition).round() / roundPosition));
        case 7:
          return rows.map((e) => Point(e.time, (e.magY * roundPosition).round() / roundPosition));
        case 8:
          return rows.map((e) => Point(e.time, (e.magZ * roundPosition).round() / roundPosition));
        case 9:
          return rows.map((e) => Point(e.time, (e.pitch * roundPosition).round() / roundPosition));
        case 10:
          return rows.map((e) => Point(e.time, (e.roll * roundPosition).round() / roundPosition));
        case 11:
          return rows.map((e) => Point(e.time, (e.yaw * roundPosition).round() / roundPosition));
        default:
          throw Exception();
      }
    });
  }

  Iterable<FootEntity> get entities => _footRepository.entities;
  Iterable<FootRow> targetRow(FootEntity entity) {
    return entity.rows;
  }
  Iterable<Iterable<FootRow>> get rowsList => _footRepository.entities
      .map((e) => targetRow(e)
        .skip((targetRow(e).length - _MAX_LENGTH > 0) ? (targetRow(e).length - _MAX_LENGTH) : 0)
      );

  @override
  List<LineChartCurveRow> get curveRow {
    Iterable<int> entityIndexOfNonNullRows = rowsList
        .indexed
        .where((element) => element.$2.isNotEmpty)
        .map((e) => e.$1);
    if(entityIndexOfNonNullRows.isEmpty) {
      return [];
    }

    Iterable<Color> colors = entities
        .indexed
        .where((element) => entityIndexOfNonNullRows.contains(element.$1))
        .map((e) => bodyPartToColors(e.$2.bodyPart))
        .reduce((value, element) => value.followedBy(element));

    Iterable<String> labelNames = entities
        .indexed
        .where((element) => entityIndexOfNonNullRows.contains(element.$1))
        .map((e) => bodyPartToListName(e.$2.bodyPart))
        .reduce((value, element) => value.followedBy(element));

    Iterable<Iterable<Iterable<Point<double>>>> pointsListOfEachEntity = rowsList
        .where((element) => element.isNotEmpty)
        .map((e) => footRowsToListPoints(e));

    Iterable<Iterable<Point<double>>> pointsList;
    if(pointsListOfEachEntity.isEmpty) {
      pointsList = const Iterable.empty();
    } else if(pointsListOfEachEntity.length == 1) {
      pointsList = pointsListOfEachEntity.first;
    } else {
      pointsList = rowsList
        .where((element) => element.isNotEmpty)
        .map((e) => footRowsToListPoints(e))
        .reduce((value, element) => value.followedBy(element));
    }

    return fillTwoSidePoints(pointsList)
        .indexed
        .map((points) => LineChartCurveRow(
          name: labelNames.skip(points.$1).first,
          points: points.$2,
          color: colors.skip(points.$1).first,
        ))
        .toList();
  }

  @override
  List<LineChartDashboardRow> get dashBoardRows {
    throw Exception();
  }
}