import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ElectrochemicalHeader {
  final String dataName;
  final String deviceId;
  final DateTime createdTime;
  final int temperature;
  final ElectrochemicalParameters parameters;
  CaElectrochemicalParameters? get caParameters => (parameters is CaElectrochemicalParameters) ? parameters as CaElectrochemicalParameters : null;
  CvElectrochemicalParameters? get cvParameters => (parameters is CvElectrochemicalParameters) ? parameters as CvElectrochemicalParameters : null;
  DpvElectrochemicalParameters? get dpvParameters => (parameters is DpvElectrochemicalParameters) ? parameters as DpvElectrochemicalParameters : null;

  ElectrochemicalType get type => parameters.type;

  ElectrochemicalHeader({
    required this.dataName,
    required this.deviceId,
    required this.createdTime,
    required this.temperature,
    required this.parameters,
  });
}
