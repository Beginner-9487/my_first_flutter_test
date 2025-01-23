import 'dart:math';

import 'package:flutter_basic_utils/presentation/dataset_color_generator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ControllerDtoMapper {
  const ControllerDtoMapper._();
  static mapElectrochemicalEntityToColor({
    required ElectrochemicalEntity entity,
    required int index,
    required int length,
  }) {
    return DatasetColorGenerator.rainbowGroup(
      alpha: 1.0,
      index: index,
      length: length,
      groupIndex: ElectrochemicalType.values.indexWhere((type) => type == entity.electrochemicalHeader.type),
      groupLength: ElectrochemicalType.values.length,
    );
  }
  static mapElectrochemicalEntitiesToLineChartSeriesList({
    required Iterable<ElectrochemicalEntity> entities,
    required ElectrochemicalLineChartMode mode,
  }) {
    return entities.indexed.map((element) {
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
                e.current,
              );
            case ElectrochemicalLineChartMode.ampereTime:
              return Point(
                e.time,
                e.current,
              );
            case ElectrochemicalLineChartMode.ampereVolt:
              return Point(
                e.voltage,
                e.current,
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
      );
    }).toList();
  }
  static mapElectrochemicalEntitiesToLineChartInfo({
    required Iterable<ElectrochemicalEntity> entities,
    required double? x,
    required ElectrochemicalLineChartMode mode,
  }) {
    if(x == null) return Iterable.empty();
    return entities.indexed.map((element) {
      int length = entities.length;
      int index = element.$1;
      var entity = element.$2;
      return ElectrochemicalLineChartInfoDto(
        color: mapElectrochemicalEntityToColor(
          entity: entity,
          index: index,
          length: length,
        ),
        createdTime: entity.electrochemicalHeader.createdTime,
        data: entity.data.where((d) {
          switch(mode) {
            case ElectrochemicalLineChartMode.ampereIndex:
              return d.index == x;
            case ElectrochemicalLineChartMode.ampereTime:
              return d.time == x;
            case ElectrochemicalLineChartMode.ampereVolt:
              return d.voltage == x;
          }
        }).map((d) {
          return ElectrochemicalLineChartInfoDtoData(
            index: d.index,
            time: d.time / 1000.0,
            voltage: d.voltage / 1000.0,
            current: d.current / 1000.0,
          );
        }).toList(),
        dataName: entity.electrochemicalHeader.dataName,
        deviceId: entity.electrochemicalHeader.deviceId,
        temperature: entity.electrochemicalHeader.temperature / 1000.0,
        type: entity.electrochemicalHeader.type,
      );
    }).toList();
  }
}
