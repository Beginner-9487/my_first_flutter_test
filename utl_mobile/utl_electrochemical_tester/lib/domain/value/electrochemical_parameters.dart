enum ElectrochemicalType {
  ca,
  cv,
  dpv,
}

abstract class ElectrochemicalParameters {
  ElectrochemicalType get type;
}

class CaElectrochemicalParameters extends ElectrochemicalParameters {
  final int eDc;
  final int tInterval;
  final int tRun;

  CaElectrochemicalParameters({
    required this.eDc,
    required this.tInterval,
    required this.tRun,
  });

  @override
  ElectrochemicalType get type => ElectrochemicalType.ca;
}

class CvElectrochemicalParameters extends ElectrochemicalParameters {
  final int eBegin;
  final int eVertex1;
  final int eVertex2;
  final int eStep;
  final int scanRate;
  final int numberOfScans;

  CvElectrochemicalParameters({
    required this.eBegin,
    required this.eVertex1,
    required this.eVertex2,
    required this.eStep,
    required this.scanRate,
    required this.numberOfScans,
  });

  @override
  ElectrochemicalType get type => ElectrochemicalType.cv;
}

class DpvElectrochemicalParameters extends ElectrochemicalParameters {
  final int eBegin;
  final int eEnd;
  final int eStep;
  final int ePulse;
  final int tPulse;
  final int scanRate;
  DpvElectrochemicalParametersInversionOption inversionOption;

  DpvElectrochemicalParameters({
    required this.eBegin,
    required this.eEnd,
    required this.eStep,
    required this.ePulse,
    required this.tPulse,
    required this.scanRate,
    required this.inversionOption,
  });

  @override
  ElectrochemicalType get type => ElectrochemicalType.dpv;
}

enum DpvElectrochemicalParametersInversionOption {
  none,
  both,
  cathodic,
  anodic,
}
