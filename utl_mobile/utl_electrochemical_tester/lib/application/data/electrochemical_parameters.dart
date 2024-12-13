abstract class ElectrochemicalParameters {}

class CaElectrochemicalParameters implements ElectrochemicalParameters {
  final int eDc;
  final int tInterval;
  final int tRun;

  CaElectrochemicalParameters({
    required this.eDc,
    required this.tInterval,
    required this.tRun,
  });
}

class CvElectrochemicalParameters implements ElectrochemicalParameters {
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
}

class DpvElectrochemicalParameters implements ElectrochemicalParameters {
  final int eBegin;
  final int eEnd;
  final int eStep;
  final int ePulse;
  final int tPulse;
  final int scanRate;

  DpvElectrochemicalParameters({
    required this.eBegin,
    required this.eEnd,
    required this.eStep,
    required this.ePulse,
    required this.tPulse,
    required this.scanRate,
  });
}
