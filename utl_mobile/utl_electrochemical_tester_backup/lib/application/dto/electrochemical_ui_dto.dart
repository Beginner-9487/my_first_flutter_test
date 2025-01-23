import 'dart:ui';

import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

class ElectrochemicalUiDtoData {
  int index;
  double time;
  double voltage;
  double current;
  ElectrochemicalUiDtoData({
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

class ElectrochemicalUiDto {
  final String dataName;
  final String deviceId;
  final DateTime createdTime;
  final ElectrochemicalType type;
  final double temperature;
  final Color color;

  final List<ElectrochemicalUiDtoData> data;

  ElectrochemicalUiDto({
    required this.color,
    required this.createdTime,
    required this.data,
    required this.dataName,
    required this.deviceId,
    required this.temperature,
    required this.type,
  });
}
