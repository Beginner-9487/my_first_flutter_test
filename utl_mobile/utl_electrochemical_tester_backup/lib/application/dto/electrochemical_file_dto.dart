class ElectrochemicalFileDto {
  final String id;
  final String dataName;
  final String deviceId;
  final String createdTime;
  final String type;
  final String temperature;

  final String caEDc;
  final String caTInterval;
  final String caTRun;
  final String cvEBegin;
  final String cvEVertex1;
  final String cvEVertex2;
  final String cvEStep;
  final String cvScanRate;
  final String cvNumberOfScans;
  final String dpvEBegin;
  final String dpvEEnd;
  final String dpvEStep;
  final String dpvEPulse;
  final String dpvTPulse;
  final String dpvScanRate;
  final String dpvInversionOption;

  final List<double> data;

  ElectrochemicalFileDto({
    required this.id,
    required this.dataName,
    required this.deviceId,
    required this.createdTime,
    required this.type,
    required this.temperature,
    this.caEDc = "",
    this.caTInterval = "",
    this.caTRun = "",
    this.cvEBegin = "",
    this.cvEVertex1 = "",
    this.cvEVertex2 = "",
    this.cvEStep = "",
    this.cvScanRate = "",
    this.cvNumberOfScans = "",
    this.dpvEBegin = "",
    this.dpvEEnd = "",
    this.dpvEStep = "",
    this.dpvEPulse = "",
    this.dpvTPulse = "",
    this.dpvScanRate = "",
    this.dpvInversionOption = "",
    required this.data,
  });
}
