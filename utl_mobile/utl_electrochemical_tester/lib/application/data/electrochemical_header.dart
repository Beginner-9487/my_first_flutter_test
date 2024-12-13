import 'package:utl_electrochemical_tester/application/data/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_type.dart';

class ElectrochemicalHeader {
  final String dataName;
  final String deviceId;
  final int createdTime;
  final int temperature;
  final ElectrochemicalParameters parameters;

  ElectrochemicalType get type {
    if (parameters is CaElectrochemicalParameters) return ElectrochemicalType.ca;
    if (parameters is CvElectrochemicalParameters) return ElectrochemicalType.cv;
    if (parameters is DpvElectrochemicalParameters) return ElectrochemicalType.dpv;
    throw Exception("Unsupported ElectrochemicalParameters type: ${parameters.runtimeType}");
  }

  ElectrochemicalHeader({
    required this.dataName,
    required this.deviceId,
    required this.createdTime,
    required this.temperature,
    required this.parameters,
  });
}
