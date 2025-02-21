import 'package:hive/hive.dart';

part 'hive_electrochemical.g.dart';

@HiveType(typeId: 0)
class HiveElectrochemicalEntity extends HiveObject {
  @HiveField(0)
  final HiveElectrochemicalHeader electrochemicalHeader;

  @HiveField(1)
  final List<HiveElectrochemicalData> data;

  HiveElectrochemicalEntity({
    required this.electrochemicalHeader,
    required this.data,
  });
}

@HiveType(typeId: 1)
class HiveElectrochemicalData extends HiveObject {
  @HiveField(0)
  final int index;

  @HiveField(1)
  final int time;

  @HiveField(2)
  final int voltage;

  @HiveField(3)
  final int current;

  HiveElectrochemicalData({
    required this.index,
    required this.time,
    required this.voltage,
    required this.current,
  });
}

@HiveType(typeId: 2)
class HiveElectrochemicalHeader extends HiveObject {
  @HiveField(0)
  final String dataName;

  @HiveField(1)
  final String deviceId;

  @HiveField(2)
  final DateTime createdTime;

  @HiveField(3)
  final int temperature;

  @HiveField(4)
  final HiveElectrochemicalParameters parameters;

  HiveElectrochemicalHeader({
    required this.dataName,
    required this.deviceId,
    required this.createdTime,
    required this.temperature,
    required this.parameters,
  });
}

@HiveType(typeId: 3)
enum HiveElectrochemicalType {
  @HiveField(0)
  ca,

  @HiveField(1)
  cv,

  @HiveField(2)
  dpv,
}

abstract class HiveElectrochemicalParameters {
  HiveElectrochemicalType get type;
}

@HiveType(typeId: 4)
class HiveCaElectrochemicalParameters extends HiveObject implements HiveElectrochemicalParameters {
  @override
  @HiveField(0)
  HiveElectrochemicalType get type => HiveElectrochemicalType.ca;

  @HiveField(1)
  final int eDc;

  @HiveField(2)
  final int tInterval;

  @HiveField(3)
  final int tRun;

  HiveCaElectrochemicalParameters({
    required this.eDc,
    required this.tInterval,
    required this.tRun,
  });
}

@HiveType(typeId: 5)
class HiveCvElectrochemicalParameters extends HiveObject implements HiveElectrochemicalParameters {
  @override
  @HiveField(0)
  HiveElectrochemicalType get type => HiveElectrochemicalType.cv;

  @HiveField(1)
  final int eBegin;

  @HiveField(2)
  final int eVertex1;

  @HiveField(3)
  final int eVertex2;

  @HiveField(4)
  final int eStep;

  @HiveField(5)
  final int scanRate;

  @HiveField(6)
  final int numberOfScans;

  HiveCvElectrochemicalParameters({
    required this.eBegin,
    required this.eVertex1,
    required this.eVertex2,
    required this.eStep,
    required this.scanRate,
    required this.numberOfScans,
  });
}

@HiveType(typeId: 6)
class HiveDpvElectrochemicalParameters extends HiveObject implements HiveElectrochemicalParameters {
  @override
  @HiveField(0)
  HiveElectrochemicalType get type => HiveElectrochemicalType.dpv;

  @HiveField(1)
  final int eBegin;

  @HiveField(2)
  final int eEnd;

  @HiveField(3)
  final int eStep;

  @HiveField(4)
  final int ePulse;

  @HiveField(5)
  final int tPulse;

  @HiveField(6)
  final int scanRate;

  @HiveField(7)
  final HiveDpvElectrochemicalParametersInversionOption inversionOption;

  HiveDpvElectrochemicalParameters({
    required this.eBegin,
    required this.eEnd,
    required this.eStep,
    required this.ePulse,
    required this.tPulse,
    required this.scanRate,
    required this.inversionOption,
  });
}

@HiveType(typeId: 7)
enum HiveDpvElectrochemicalParametersInversionOption {
  @HiveField(0)
  none,

  @HiveField(1)
  both,

  @HiveField(2)
  cathodic,

  @HiveField(3)
  anodic,
}
