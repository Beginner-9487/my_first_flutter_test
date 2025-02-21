import 'dart:math';
import 'dart:ui';

import 'package:flutter_basic_utils/presentation/dataset_color_generator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ControllerDtoMapper {
  const ControllerDtoMapper._();
  static double mapLineChartXToEntity({
    required double x,
    required ElectrochemicalLineChartMode mode,
  }) {
    switch(mode) {
      case ElectrochemicalLineChartMode.ampereIndex:
        return x;
      case ElectrochemicalLineChartMode.ampereTime:
        return x * 1e3;
      case ElectrochemicalLineChartMode.ampereVolt:
        return x * 1e3;
    }
  }
  static Color mapElectrochemicalEntityToColor({
    required ElectrochemicalEntity entity,
    required int index,
    required int length,
  }) {
    return DatasetColorGenerator.rainbowGroup(
      alpha: 1.0,
      index: index + 10,
      length: length + 10,
      groupIndex: ElectrochemicalType.values.indexWhere((type) => type == entity.electrochemicalHeader.type),
      groupLength: ElectrochemicalType.values.length,
    );
  }
  static List<LineSeries<Point<num>, double>> mapElectrochemicalEntitiesToLineChartSeriesList({
    required Iterable<ElectrochemicalEntity> entities,
    required Map<ElectrochemicalType, bool> shows,
    required ElectrochemicalLineChartMode mode,
  }) {
    return entities
      .where((entity) => shows[entity.electrochemicalHeader.type]!)
      .indexed.map((element) {
        int length = entities.length;
        int index = element.$1;
        var entity = element.$2;
        return LineSeries<Point, double>(
          name: entity.electrochemicalHeader.dataName,
          dataSource: entity.data.map((e) {
            switch(mode) {
              case ElectrochemicalLineChartMode.ampereIndex:
                return Point(
                  e.index,
                  e.current / 1e3,
                );
              case ElectrochemicalLineChartMode.ampereTime:
                return Point(
                  e.time / 1e3,
                  e.current / 1e3,
                );
              case ElectrochemicalLineChartMode.ampereVolt:
                return Point(
                  e.voltage / 1e3,
                  e.current / 1e3,
                );
            }
          }).toList(),
          animationDuration: 0,
          xValueMapper: (Point data, _) => data.x.toDouble(),
          yValueMapper: (Point data, _) => data.y.toDouble(),
          color: mapElectrochemicalEntityToColor(
            entity: entity,
            index: index,
            length: length,
          ),
          width: 1.5,
          // markerSettings: MarkerSettings(isVisible: true),
        );
      }).toList();
  }
  static List<ElectrochemicalLineChartInfoDto> mapElectrochemicalEntitiesToLineChartInfo({
    required Iterable<ElectrochemicalEntity> entities,
    required double? x,
    required Map<ElectrochemicalType, bool> shows,
    required ElectrochemicalLineChartMode mode,
  }) {
    return entities
      .where((entity) => shows[entity.electrochemicalHeader.type]!)
      .indexed.map((element) {
        int length = entities.length;
        int index = element.$1;
        var entity = element.$2;
        final data = (x == null)
          ? List<ElectrochemicalLineChartInfoDtoData>.empty()
          : entity.data.where((d) {
            final infoX = mapLineChartXToEntity(
              x: x,
              mode: mode,
            );
            switch(mode) {
              case ElectrochemicalLineChartMode.ampereIndex:
                return d.index == infoX;
              case ElectrochemicalLineChartMode.ampereTime:
                return d.time == infoX;
              case ElectrochemicalLineChartMode.ampereVolt:
                return d.voltage == infoX;
            }
          }).map((d) {
            return ElectrochemicalLineChartInfoDtoData(
              index: d.index,
              time: d.time / 1e3,
              voltage: d.voltage / 1e3,
              current: d.current / 1e3,
            );
          }).toList();
        return ElectrochemicalLineChartInfoDto(
          color: mapElectrochemicalEntityToColor(
            entity: entity,
            index: index,
            length: length,
          ),
          createdTime: entity.electrochemicalHeader.createdTime,
          data: data,
          dataName: entity.electrochemicalHeader.dataName,
          deviceId: entity.electrochemicalHeader.deviceId,
          temperature: entity.electrochemicalHeader.temperature / 1e6,
          type: entity.electrochemicalHeader.type,
        );
      }).toList();
  }
}
