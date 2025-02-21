import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'hive_electrochemical.dart';

class HiveElectrochemicalMapper {
  HiveElectrochemicalMapper._();

  static HiveElectrochemicalEntity fromEntity(ElectrochemicalEntity entity) {
    return HiveElectrochemicalEntity(
      electrochemicalHeader: fromHeader(entity.electrochemicalHeader),
      data: entity.data.map(fromData).toList(),
    );
  }

  static HiveElectrochemicalHeader fromHeader(ElectrochemicalHeader header) {
    return HiveElectrochemicalHeader(
      dataName: header.dataName,
      deviceId: header.deviceId,
      createdTime: header.createdTime,
      temperature: header.temperature,
      parameters: fromParameters(header.parameters),
    );
  }

  static HiveElectrochemicalData fromData(ElectrochemicalData data) {
    return HiveElectrochemicalData(
      index: data.index,
      time: data.time,
      voltage: data.voltage,
      current: data.current,
    );
  }

  static HiveElectrochemicalParameters fromParameters(ElectrochemicalParameters parameters) {
    if (parameters is CaElectrochemicalParameters) {
      return HiveCaElectrochemicalParameters(
        eDc: parameters.eDc,
        tInterval: parameters.tInterval,
        tRun: parameters.tRun,
      );
    } else if (parameters is CvElectrochemicalParameters) {
      return HiveCvElectrochemicalParameters(
        eBegin: parameters.eBegin,
        eVertex1: parameters.eVertex1,
        eVertex2: parameters.eVertex2,
        eStep: parameters.eStep,
        scanRate: parameters.scanRate,
        numberOfScans: parameters.numberOfScans,
      );
    } else if (parameters is DpvElectrochemicalParameters) {
      return HiveDpvElectrochemicalParameters(
        eBegin: parameters.eBegin,
        eEnd: parameters.eEnd,
        eStep: parameters.eStep,
        ePulse: parameters.ePulse,
        tPulse: parameters.tPulse,
        scanRate: parameters.scanRate,
        inversionOption: fromInversionOption(parameters.inversionOption),
      );
    } else {
      throw ArgumentError('Unknown ElectrochemicalParameters type');
    }
  }

  static HiveDpvElectrochemicalParametersInversionOption fromInversionOption(DpvElectrochemicalParametersInversionOption option) {
    switch (option) {
      case DpvElectrochemicalParametersInversionOption.none:
        return HiveDpvElectrochemicalParametersInversionOption.none;
      case DpvElectrochemicalParametersInversionOption.both:
        return HiveDpvElectrochemicalParametersInversionOption.both;
      case DpvElectrochemicalParametersInversionOption.cathodic:
        return HiveDpvElectrochemicalParametersInversionOption.cathodic;
      case DpvElectrochemicalParametersInversionOption.anodic:
        return HiveDpvElectrochemicalParametersInversionOption.anodic;
    }
  }

  static ElectrochemicalEntity toEntity(int key, HiveElectrochemicalEntity entity) {
    return ElectrochemicalEntity(
      id: key,
      electrochemicalHeader: toHeader(entity.electrochemicalHeader),
      data: entity.data.map(toData).toList(),
    );
  }

  static ElectrochemicalHeader toHeader(HiveElectrochemicalHeader header) {
    return ElectrochemicalHeader(
      dataName: header.dataName,
      deviceId: header.deviceId,
      createdTime: header.createdTime,
      temperature: header.temperature,
      parameters: toParameters(header.parameters),
    );
  }

  static ElectrochemicalData toData(HiveElectrochemicalData data) {
    return ElectrochemicalData(
      index: data.index,
      time: data.time,
      voltage: data.voltage,
      current: data.current,
    );
  }

  static ElectrochemicalParameters toParameters(HiveElectrochemicalParameters parameters) {
    if (parameters is HiveCaElectrochemicalParameters) {
      return CaElectrochemicalParameters(
        eDc: parameters.eDc,
        tInterval: parameters.tInterval,
        tRun: parameters.tRun,
      );
    } else if (parameters is HiveCvElectrochemicalParameters) {
      return CvElectrochemicalParameters(
        eBegin: parameters.eBegin,
        eVertex1: parameters.eVertex1,
        eVertex2: parameters.eVertex2,
        eStep: parameters.eStep,
        scanRate: parameters.scanRate,
        numberOfScans: parameters.numberOfScans,
      );
    } else if (parameters is HiveDpvElectrochemicalParameters) {
      return DpvElectrochemicalParameters(
        eBegin: parameters.eBegin,
        eEnd: parameters.eEnd,
        eStep: parameters.eStep,
        ePulse: parameters.ePulse,
        tPulse: parameters.tPulse,
        scanRate: parameters.scanRate,
        inversionOption: toInversionOption(parameters.inversionOption),
      );
    } else {
      throw ArgumentError('Unknown HiveElectrochemicalParameters type');
    }
  }

  static DpvElectrochemicalParametersInversionOption toInversionOption(HiveDpvElectrochemicalParametersInversionOption option) {
    switch (option) {
      case HiveDpvElectrochemicalParametersInversionOption.none:
        return DpvElectrochemicalParametersInversionOption.none;
      case HiveDpvElectrochemicalParametersInversionOption.both:
        return DpvElectrochemicalParametersInversionOption.both;
      case HiveDpvElectrochemicalParametersInversionOption.cathodic:
        return DpvElectrochemicalParametersInversionOption.cathodic;
      case HiveDpvElectrochemicalParametersInversionOption.anodic:
        return DpvElectrochemicalParametersInversionOption.anodic;
    }
  }
}
