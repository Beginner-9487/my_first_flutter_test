import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ElectrochemicalDeviceReceivedHeaderDto {
  ElectrochemicalDeviceReceivedHeaderDto({
    required this.dataName,
    required this.deviceId,
    required this.deviceName,
    required this.createdTime,
    required this.parameters,
    required this.temperature,
  });
  final String dataName;
  final String deviceId;
  final String deviceName;
  final DateTime createdTime;
  final ElectrochemicalParameters parameters;
  final int temperature;
}

class ElectrochemicalDeviceReceivedDataDto {
  ElectrochemicalDeviceReceivedDataDto({
    required this.entityId,
    required this.index,
    required this.time,
    required this.voltage,
    required this.current,
  });
  final int entityId;
  final int index;
  final int time;
  final int voltage;
  final int current;
}
