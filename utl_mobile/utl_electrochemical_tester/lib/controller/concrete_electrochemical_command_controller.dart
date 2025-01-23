import 'dart:async';

import 'package:utl_electrochemical_tester/adapter/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/adapter/dto/electrochemical_device_sent_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/service/shared_preferences_service.dart';

class ConcreteElectrochemicalCommandController implements ElectrochemicalCommandController {
  final ElectrochemicalDevicesManager electrochemicalDevicesManager;
  final SharedPreferencesService sharedPreferencesService;
  ConcreteElectrochemicalCommandController({
    required this.electrochemicalDevicesManager,
    required this.sharedPreferencesService,
  });

  @override
  Ad5940ParametersHsTiaRTia getAd5940ParametersHsTiaRTia() {
    return sharedPreferencesService.getAd5940ParametersHsTiaRTia();
  }

  @override
  int getCaElectrochemicalParametersEDc() {
    return sharedPreferencesService.getCaElectrochemicalParametersEDc();
  }

  @override
  int getCaElectrochemicalParametersTInterval() {
    return sharedPreferencesService.getCaElectrochemicalParametersTInterval();
  }

  @override
  int getCaElectrochemicalParametersTRun() {
    return sharedPreferencesService.getCaElectrochemicalParametersTRun();
  }

  @override
  int getCommandTabIndexBuffer() {
    return sharedPreferencesService.getElectrochemicalCommandTabIndexBufferKey();
  }

  @override
  int getCvElectrochemicalParametersEBegin() {
    return sharedPreferencesService.getCvElectrochemicalParametersEBegin();
  }

  @override
  int getCvElectrochemicalParametersEStep() {
    return sharedPreferencesService.getCvElectrochemicalParametersEStep();
  }

  @override
  int getCvElectrochemicalParametersEVertex1() {
    return sharedPreferencesService.getCvElectrochemicalParametersEVertex1();
  }

  @override
  int getCvElectrochemicalParametersEVertex2() {
    return sharedPreferencesService.getCvElectrochemicalParametersEVertex2();
  }

  @override
  int getCvElectrochemicalParametersNumberOfScans() {
    return sharedPreferencesService.getCvElectrochemicalParametersNumberOfScans();
  }

  @override
  int getCvElectrochemicalParametersScanRate() {
    return sharedPreferencesService.getCvElectrochemicalParametersScanRate();
  }

  @override
  String getDataNameBuffer() {
    return sharedPreferencesService.getElectrochemicalDataNameBuffer();
  }

  @override
  int getDpvElectrochemicalParametersEBegin() {
    return sharedPreferencesService.getDpvElectrochemicalParametersEBegin();
  }

  @override
  int getDpvElectrochemicalParametersEEnd() {
    return sharedPreferencesService.getDpvElectrochemicalParametersEEnd();
  }

  @override
  int getDpvElectrochemicalParametersEPulse() {
    return sharedPreferencesService.getDpvElectrochemicalParametersEPulse();
  }

  @override
  int getDpvElectrochemicalParametersEStep() {
    return sharedPreferencesService.getDpvElectrochemicalParametersEStep();
  }

  @override
  DpvElectrochemicalParametersInversionOption getDpvElectrochemicalParametersInversionOption() {
    return sharedPreferencesService.getDpvElectrochemicalParametersInversionOption();
  }

  @override
  int getDpvElectrochemicalParametersScanRate() {
    return sharedPreferencesService.getDpvElectrochemicalParametersScanRate();
  }

  @override
  int getDpvElectrochemicalParametersTPulse() {
    return sharedPreferencesService.getDpvElectrochemicalParametersTPulse();
  }

  @override
  void setAd5940ParametersHsTiaRTia(Ad5940ParametersHsTiaRTia ad5940ParametersHsTiaRTia) {
    sharedPreferencesService.setAd5940ParametersHsTiaRTia(ad5940ParametersHsTiaRTia);
  }

  @override
  void setCaElectrochemicalParametersEDc(int eDc) {
    sharedPreferencesService.setCaElectrochemicalParametersEDc(eDc);
  }

  @override
  void setCaElectrochemicalParametersTInterval(int tInterval) {
    sharedPreferencesService.setCaElectrochemicalParametersTInterval(tInterval);
  }

  @override
  void setCaElectrochemicalParametersTRun(int tRun) {
    sharedPreferencesService.setCaElectrochemicalParametersTRun(tRun);
  }

  @override
  void setCommandTabIndexBuffer(int index) {
    sharedPreferencesService.setElectrochemicalCommandTabIndexBufferKey(index);
  }

  @override
  void setCvElectrochemicalParametersEBegin(int eBegin) {
    sharedPreferencesService.setCvElectrochemicalParametersEBegin(eBegin);
  }

  @override
  void setCvElectrochemicalParametersEStep(int eStep) {
    sharedPreferencesService.setCvElectrochemicalParametersEStep(eStep);
  }

  @override
  void setCvElectrochemicalParametersEVertex1(int eVertex1) {
    sharedPreferencesService.setCvElectrochemicalParametersEVertex1(eVertex1);
  }

  @override
  void setCvElectrochemicalParametersEVertex2(int eVertex2) {
    sharedPreferencesService.setCvElectrochemicalParametersEVertex2(eVertex2);
  }

  @override
  void setCvElectrochemicalParametersNumberOfScans(int numberOfScans) {
    sharedPreferencesService.setCvElectrochemicalParametersNumberOfScans(numberOfScans);
  }

  @override
  void setCvElectrochemicalParametersScanRate(int scanRate) {
    sharedPreferencesService.setCvElectrochemicalParametersScanRate(scanRate);
  }

  @override
  void setDataNameBuffer(String dataName) {
    sharedPreferencesService.setElectrochemicalDataNameBuffer(dataName);
  }

  @override
  void setDpvElectrochemicalParametersEBegin(int eBegin) {
    sharedPreferencesService.setDpvElectrochemicalParametersEBegin(eBegin);
  }

  @override
  void setDpvElectrochemicalParametersEEnd(int eEnd) {
    sharedPreferencesService.setDpvElectrochemicalParametersEEnd(eEnd);
  }

  @override
  void setDpvElectrochemicalParametersEPulse(int ePulse) {
    sharedPreferencesService.setDpvElectrochemicalParametersEPulse(ePulse);
  }

  @override
  void setDpvElectrochemicalParametersEStep(int eStep) {
    sharedPreferencesService.setDpvElectrochemicalParametersEStep(eStep);
  }

  @override
  void setDpvElectrochemicalParametersInversionOption(DpvElectrochemicalParametersInversionOption inversionOption) {
    sharedPreferencesService.setDpvElectrochemicalParametersInversionOption(inversionOption);
  }

  @override
  void setDpvElectrochemicalParametersScanRate(int scanRate) {
    sharedPreferencesService.setDpvElectrochemicalParametersScanRate(scanRate);
  }

  @override
  void setDpvElectrochemicalParametersTPulse(int tPulse) {
    sharedPreferencesService.setDpvElectrochemicalParametersTPulse(tPulse);
  }

  @override
  Future<void> start({required ElectrochemicalType type}) async {
    for(var device in electrochemicalDevicesManager.devices.toList()) {
      switch (type) {
        case ElectrochemicalType.ca:
          await device.startCa(
            dto: CaElectrochemicalDeviceSentDto(
              ad5940Parameters: Ad5940Parameters(
                hsTiaRTia: getAd5940ParametersHsTiaRTia(),
              ),
              dataName: getDataNameBuffer(),
              electrochemicalParameters: CaElectrochemicalParameters(
                eDc: getCaElectrochemicalParametersEDc(),
                tInterval: getCaElectrochemicalParametersTInterval(),
                tRun: getCaElectrochemicalParametersTRun(),
              ),
            ),
          );
          break;
        case ElectrochemicalType.cv:
          await device.startCv(
            dto: CvElectrochemicalDeviceSentDto(
              ad5940Parameters: Ad5940Parameters(
                hsTiaRTia: getAd5940ParametersHsTiaRTia(),
              ),
              dataName: getDataNameBuffer(),
              electrochemicalParameters: CvElectrochemicalParameters(
                eBegin: getCvElectrochemicalParametersEBegin(),
                eVertex1: getCvElectrochemicalParametersEVertex1(),
                eVertex2: getCvElectrochemicalParametersEVertex2(),
                eStep: getCvElectrochemicalParametersEStep(),
                scanRate: getCvElectrochemicalParametersScanRate(),
                numberOfScans: getCvElectrochemicalParametersNumberOfScans(),
              ),
            ),
          );
          break;
        case ElectrochemicalType.dpv:
          await device.startDpv(
            dto: DpvElectrochemicalDeviceSentDto(
              ad5940Parameters: Ad5940Parameters(
                hsTiaRTia: getAd5940ParametersHsTiaRTia(),
              ),
              dataName: getDataNameBuffer(),
              electrochemicalParameters: DpvElectrochemicalParameters(
                eBegin: getDpvElectrochemicalParametersEBegin(),
                eEnd: getDpvElectrochemicalParametersEEnd(),
                eStep: getDpvElectrochemicalParametersEStep(),
                ePulse: getDpvElectrochemicalParametersEPulse(),
                tPulse: getDpvElectrochemicalParametersTPulse(),
                scanRate: getDpvElectrochemicalParametersScanRate(),
                inversionOption: getDpvElectrochemicalParametersInversionOption(),
              ),
            ),
          );
          break;
      }
    }
  }
}
