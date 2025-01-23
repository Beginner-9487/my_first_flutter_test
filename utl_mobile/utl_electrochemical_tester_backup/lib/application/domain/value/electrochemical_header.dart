import 'package:hive_flutter/adapters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

part 'electrochemical_header.g.dart';

@HiveType(typeId: 20)
class ElectrochemicalHeader {
  @HiveField(2)
  final String dataName;
  @HiveField(3)
  final String deviceId;
  @HiveField(4)
  final int createdTime;
  @HiveField(5)
  final int temperature;
  @HiveField(6)
  final ElectrochemicalParameters parameters;

  ElectrochemicalType get type => parameters.type;

  ElectrochemicalHeader({
    required this.dataName,
    required this.deviceId,
    required this.createdTime,
    required this.temperature,
    required this.parameters,
  });
}
