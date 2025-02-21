import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/adapter/local_storage/electrochemical_command_local_storage_handler.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/shared_preferences/shared_preferences_handler.dart';

class ConcreteElectrochemicalCommandLocalStorageHandler implements ElectrochemicalCommandLocalStorageHandler {
  final SharedPreferencesHandler sharedPreferencesHandler;

  const ConcreteElectrochemicalCommandLocalStorageHandler({
    required this.sharedPreferencesHandler,
  });

  @override
  Ad5940ParametersElectrochemicalWorkingElectrode getAd5940ParametersElectrochemicalWorkingElectrode() {
    return sharedPreferencesHandler.getAd5940ParametersElectrochemicalWorkingElectrode();
  }

  @override
  Ad5940ParametersHsTiaRTia getAd5940ParametersHsTiaRTia() {
    return sharedPreferencesHandler.getAd5940ParametersHsTiaRTia();
  }
  @override
  int getCaElectrochemicalParametersEDc() {
    return sharedPreferencesHandler.getCaElectrochemicalParametersEDc();
  }

  @override
  int getCaElectrochemicalParametersTInterval() {
    return sharedPreferencesHandler.getCaElectrochemicalParametersTInterval();
  }

  @override
  int getCaElectrochemicalParametersTRun() {
    return sharedPreferencesHandler.getCaElectrochemicalParametersTRun();
  }

  @override
  int getCommandTabIndexBuffer() {
    return sharedPreferencesHandler.getElectrochemicalCommandTabIndexBuffer();
  }

  @override
  int getCvElectrochemicalParametersEBegin() {
    return sharedPreferencesHandler.getCvElectrochemicalParametersEBegin();
  }

  @override
  int getCvElectrochemicalParametersEStep() {
    return sharedPreferencesHandler.getCvElectrochemicalParametersEStep();
  }

  @override
  int getCvElectrochemicalParametersEVertex1() {
    return sharedPreferencesHandler.getCvElectrochemicalParametersEVertex1();
  }

  @override
  int getCvElectrochemicalParametersEVertex2() {
    return sharedPreferencesHandler.getCvElectrochemicalParametersEVertex2();
  }

  @override
  int getCvElectrochemicalParametersNumberOfScans() {
    return sharedPreferencesHandler.getCvElectrochemicalParametersNumberOfScans();
  }

  @override
  int getCvElectrochemicalParametersScanRate() {
    return sharedPreferencesHandler.getCvElectrochemicalParametersScanRate();
  }

  @override
  String getDataNameBuffer() {
    return sharedPreferencesHandler.getElectrochemicalDataNameBuffer();
  }

  @override
  int getDpvElectrochemicalParametersEBegin() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersEBegin();
  }

  @override
  int getDpvElectrochemicalParametersEEnd() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersEEnd();
  }

  @override
  int getDpvElectrochemicalParametersEPulse() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersEPulse();
  }

  @override
  int getDpvElectrochemicalParametersEStep() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersEStep();
  }

  @override
  DpvElectrochemicalParametersInversionOption getDpvElectrochemicalParametersInversionOption() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersInversionOption();
  }

  @override
  int getDpvElectrochemicalParametersScanRate() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersScanRate();
  }

  @override
  int getDpvElectrochemicalParametersTPulse() {
    return sharedPreferencesHandler.getDpvElectrochemicalParametersTPulse();
  }

  @override
  void setAd5940ParametersElectrochemicalWorkingElectrode(Ad5940ParametersElectrochemicalWorkingElectrode ad5940ParametersElectrochemicalWorkingElectrode) {
    sharedPreferencesHandler.setAd5940ParametersElectrochemicalWorkingElectrode(ad5940ParametersElectrochemicalWorkingElectrode);
  }

  @override
  void setAd5940ParametersHsTiaRTia(Ad5940ParametersHsTiaRTia ad5940ParametersHsTiaRTia) {
    sharedPreferencesHandler.setAd5940ParametersHsTiaRTia(ad5940ParametersHsTiaRTia);
  }

  @override
  void setCaElectrochemicalParametersEDc(int eDc) {
    sharedPreferencesHandler.setCaElectrochemicalParametersEDc(eDc);
  }

  @override
  void setCaElectrochemicalParametersTInterval(int tInterval) {
    sharedPreferencesHandler.setCaElectrochemicalParametersTInterval(tInterval);
  }

  @override
  void setCaElectrochemicalParametersTRun(int tRun) {
    sharedPreferencesHandler.setCaElectrochemicalParametersTRun(tRun);
  }

  @override
  void setCommandTabIndexBuffer(int index) {
    sharedPreferencesHandler.setElectrochemicalCommandTabIndexBuffer(index);
  }

  @override
  void setCvElectrochemicalParametersEBegin(int eBegin) {
    sharedPreferencesHandler.setCvElectrochemicalParametersEBegin(eBegin);
  }

  @override
  void setCvElectrochemicalParametersEStep(int eStep) {
    sharedPreferencesHandler.setCvElectrochemicalParametersEStep(eStep);
  }

  @override
  void setCvElectrochemicalParametersEVertex1(int eVertex1) {
    sharedPreferencesHandler.setCvElectrochemicalParametersEVertex1(eVertex1);
  }

  @override
  void setCvElectrochemicalParametersEVertex2(int eVertex2) {
    sharedPreferencesHandler.setCvElectrochemicalParametersEVertex2(eVertex2);
  }

  @override
  void setCvElectrochemicalParametersNumberOfScans(int numberOfScans) {
    sharedPreferencesHandler.setCvElectrochemicalParametersNumberOfScans(numberOfScans);
  }

  @override
  void setCvElectrochemicalParametersScanRate(int scanRate) {
    sharedPreferencesHandler.setCvElectrochemicalParametersScanRate(scanRate);
  }

  @override
  void setDataNameBuffer(String dataName) {
    sharedPreferencesHandler.setElectrochemicalDataNameBuffer(dataName);
  }

  @override
  void setDpvElectrochemicalParametersEBegin(int eBegin) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersEBegin(eBegin);
  }

  @override
  void setDpvElectrochemicalParametersEEnd(int eEnd) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersEEnd(eEnd);
  }

  @override
  void setDpvElectrochemicalParametersEPulse(int ePulse) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersEPulse(ePulse);
  }

  @override
  void setDpvElectrochemicalParametersEStep(int eStep) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersEStep(eStep);
  }

  @override
  void setDpvElectrochemicalParametersInversionOption(DpvElectrochemicalParametersInversionOption inversionOption) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersInversionOption(inversionOption);
  }

  @override
  void setDpvElectrochemicalParametersScanRate(int scanRate) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersScanRate(scanRate);
  }

  @override
  void setDpvElectrochemicalParametersTPulse(int tPulse) {
    sharedPreferencesHandler.setDpvElectrochemicalParametersTPulse(tPulse);
  }
}