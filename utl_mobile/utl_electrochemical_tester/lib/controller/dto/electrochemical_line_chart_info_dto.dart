import 'dart:ui';

import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ElectrochemicalLineChartInfoDtoData {
  int index;
  double time;
  double voltage;
  double current;
  ElectrochemicalLineChartInfoDtoData({
    required this.index,
    required this.time,
    required this.voltage,
    required this.current,
  });

  @override
  String toString() {
    return "ElectrochemicalUiDtoData: index: $index, time: $time, voltage: $voltage, current: $current";
  }
}

class ElectrochemicalLineChartInfoDto {
  final String dataName;
  final String deviceId;
  final DateTime createdTime;
  final ElectrochemicalType type;
  final double temperature;
  final Color color;

  final List<ElectrochemicalLineChartInfoDtoData> data;

  ElectrochemicalLineChartInfoDto({
    required this.color,
    required this.createdTime,
    required this.data,
    required this.dataName,
    required this.deviceId,
    required this.temperature,
    required this.type,
  });
}
