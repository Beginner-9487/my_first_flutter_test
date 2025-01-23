import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_electrochemical_tester/adapter/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class SharedPreferencesService {
  SharedPreferences sharedPreferences;
  SharedPreferencesService({
    required this.sharedPreferences,
  });

  static const String _electrochemicalCommandTabIndexBufferKey = "_electrochemicalCommandTabIndexBufferKey";
  Future<bool> setElectrochemicalCommandTabIndexBufferKey(int index) => sharedPreferences.setInt(_electrochemicalCommandTabIndexBufferKey, index);
  int getElectrochemicalCommandTabIndexBufferKey() => sharedPreferences.getInt(_electrochemicalCommandTabIndexBufferKey) ?? 0;

  static const _electrochemicalDataNameBufferKey = "_electrochemicalDataNameBufferKey";
  Future<bool> setElectrochemicalDataNameBuffer(String dataName) => sharedPreferences.setString(_electrochemicalDataNameBufferKey, dataName);
  String getElectrochemicalDataNameBuffer() => sharedPreferences.getString(_electrochemicalDataNameBufferKey) ?? "";

// Ad5940ParametersHsTiaRTia
  static const _ad5940ParametersHsTiaRTiaKey = "_ad5940ParametersHsTiaRTiaKey";
  Future<bool> setAd5940ParametersHsTiaRTia(Ad5940ParametersHsTiaRTia ad5940ParametersHsTiaRTia) =>
      sharedPreferences.setInt(_ad5940ParametersHsTiaRTiaKey, ad5940ParametersHsTiaRTia.index);
  Ad5940ParametersHsTiaRTia getAd5940ParametersHsTiaRTia() =>
      Ad5940ParametersHsTiaRTia.values[(sharedPreferences.getInt(_ad5940ParametersHsTiaRTiaKey) ?? 0)];

// CaElectrochemicalParametersEDc
  static const _caElectrochemicalParametersEDcKey = "_caElectrochemicalParametersEDcKey";
  Future<bool> setCaElectrochemicalParametersEDc(int eDc) =>
      sharedPreferences.setInt(_caElectrochemicalParametersEDcKey, eDc);
  int getCaElectrochemicalParametersEDc() =>
      sharedPreferences.getInt(_caElectrochemicalParametersEDcKey) ?? 0;

// CaElectrochemicalParametersTInterval
  static const _caElectrochemicalParametersTIntervalKey = "_caElectrochemicalParametersTIntervalKey";
  Future<bool> setCaElectrochemicalParametersTInterval(int tInterval) =>
      sharedPreferences.setInt(_caElectrochemicalParametersTIntervalKey, tInterval);
  int getCaElectrochemicalParametersTInterval() =>
      sharedPreferences.getInt(_caElectrochemicalParametersTIntervalKey) ?? 0;

// CaElectrochemicalParametersTRun
  static const _caElectrochemicalParametersTRunKey = "_caElectrochemicalParametersTRunKey";
  Future<bool> setCaElectrochemicalParametersTRun(int tRun) =>
      sharedPreferences.setInt(_caElectrochemicalParametersTRunKey, tRun);
  int getCaElectrochemicalParametersTRun() =>
      sharedPreferences.getInt(_caElectrochemicalParametersTRunKey) ?? 0;

// CvElectrochemicalParametersEBegin
  static const _cvElectrochemicalParametersEBeginKey = "_cvElectrochemicalParametersEBeginKey";
  Future<bool> setCvElectrochemicalParametersEBegin(int eBegin) =>
      sharedPreferences.setInt(_cvElectrochemicalParametersEBeginKey, eBegin);
  int getCvElectrochemicalParametersEBegin() =>
      sharedPreferences.getInt(_cvElectrochemicalParametersEBeginKey) ?? 0;

// CvElectrochemicalParametersEVertex1
  static const _cvElectrochemicalParametersEVertex1Key = "_cvElectrochemicalParametersEVertex1Key";
  Future<bool> setCvElectrochemicalParametersEVertex1(int eVertex1) =>
      sharedPreferences.setInt(_cvElectrochemicalParametersEVertex1Key, eVertex1);
  int getCvElectrochemicalParametersEVertex1() =>
      sharedPreferences.getInt(_cvElectrochemicalParametersEVertex1Key) ?? 0;

// CvElectrochemicalParametersEVertex2
  static const _cvElectrochemicalParametersEVertex2Key = "_cvElectrochemicalParametersEVertex2Key";
  Future<bool> setCvElectrochemicalParametersEVertex2(int eVertex2) =>
      sharedPreferences.setInt(_cvElectrochemicalParametersEVertex2Key, eVertex2);
  int getCvElectrochemicalParametersEVertex2() =>
      sharedPreferences.getInt(_cvElectrochemicalParametersEVertex2Key) ?? 0;

// CvElectrochemicalParametersEStep
  static const _cvElectrochemicalParametersEStepKey = "_cvElectrochemicalParametersEStepKey";
  Future<bool> setCvElectrochemicalParametersEStep(int eStep) =>
      sharedPreferences.setInt(_cvElectrochemicalParametersEStepKey, eStep);
  int getCvElectrochemicalParametersEStep() =>
      sharedPreferences.getInt(_cvElectrochemicalParametersEStepKey) ?? 0;

// CvElectrochemicalParametersScanRate
  static const _cvElectrochemicalParametersScanRateKey = "_cvElectrochemicalParametersScanRateKey";
  Future<bool> setCvElectrochemicalParametersScanRate(int scanRate) =>
      sharedPreferences.setInt(_cvElectrochemicalParametersScanRateKey, scanRate);
  int getCvElectrochemicalParametersScanRate() =>
      sharedPreferences.getInt(_cvElectrochemicalParametersScanRateKey) ?? 0;

// CvElectrochemicalParametersNumberOfScans
  static const _cvElectrochemicalParametersNumberOfScansKey = "_cvElectrochemicalParametersNumberOfScansKey";
  Future<bool> setCvElectrochemicalParametersNumberOfScans(int numberOfScans) =>
      sharedPreferences.setInt(_cvElectrochemicalParametersNumberOfScansKey, numberOfScans);
  int getCvElectrochemicalParametersNumberOfScans() =>
      sharedPreferences.getInt(_cvElectrochemicalParametersNumberOfScansKey) ?? 0;

// DpvElectrochemicalParametersEBegin
  static const _dpvElectrochemicalParametersEBeginKey = "_dpvElectrochemicalParametersEBeginKey";
  Future<bool> setDpvElectrochemicalParametersEBegin(int eBegin) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersEBeginKey, eBegin);
  int getDpvElectrochemicalParametersEBegin() =>
      sharedPreferences.getInt(_dpvElectrochemicalParametersEBeginKey) ?? 0;

// DpvElectrochemicalParametersEEnd
  static const _dpvElectrochemicalParametersEEndKey = "_dpvElectrochemicalParametersEEndKey";
  Future<bool> setDpvElectrochemicalParametersEEnd(int eEnd) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersEEndKey, eEnd);
  int getDpvElectrochemicalParametersEEnd() =>
      sharedPreferences.getInt(_dpvElectrochemicalParametersEEndKey) ?? 0;

// DpvElectrochemicalParametersEStep
  static const _dpvElectrochemicalParametersEStepKey = "_dpvElectrochemicalParametersEStepKey";
  Future<bool> setDpvElectrochemicalParametersEStep(int eStep) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersEStepKey, eStep);
  int getDpvElectrochemicalParametersEStep() =>
      sharedPreferences.getInt(_dpvElectrochemicalParametersEStepKey) ?? 0;

// DpvElectrochemicalParametersEPulse
  static const _dpvElectrochemicalParametersEPulseKey = "_dpvElectrochemicalParametersEPulseKey";
  Future<bool> setDpvElectrochemicalParametersEPulse(int ePulse) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersEPulseKey, ePulse);
  int getDpvElectrochemicalParametersEPulse() =>
      sharedPreferences.getInt(_dpvElectrochemicalParametersEPulseKey) ?? 0;

// DpvElectrochemicalParametersTPulse
  static const _dpvElectrochemicalParametersTPulseKey = "_dpvElectrochemicalParametersTPulseKey";
  Future<bool> setDpvElectrochemicalParametersTPulse(int tPulse) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersTPulseKey, tPulse);
  int getDpvElectrochemicalParametersTPulse() =>
      sharedPreferences.getInt(_dpvElectrochemicalParametersTPulseKey) ?? 0;

// DpvElectrochemicalParametersScanRate
  static const _dpvElectrochemicalParametersScanRateKey = "_dpvElectrochemicalParametersScanRateKey";
  Future<bool> setDpvElectrochemicalParametersScanRate(int scanRate) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersScanRateKey, scanRate);
  int getDpvElectrochemicalParametersScanRate() =>
      sharedPreferences.getInt(_dpvElectrochemicalParametersScanRateKey) ?? 0;

// DpvElectrochemicalParametersInversionOption
  static const _dpvElectrochemicalParametersInversionOptionKey = "_dpvElectrochemicalParametersInversionOptionKey";
  Future<bool> setDpvElectrochemicalParametersInversionOption(DpvElectrochemicalParametersInversionOption inversionOption) =>
      sharedPreferences.setInt(_dpvElectrochemicalParametersInversionOptionKey, inversionOption.index);
  DpvElectrochemicalParametersInversionOption getDpvElectrochemicalParametersInversionOption() =>
      DpvElectrochemicalParametersInversionOption.values[(sharedPreferences.getInt(_dpvElectrochemicalParametersInversionOptionKey) ?? 0)];

}
