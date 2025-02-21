import 'dart:async';

import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_sent_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/electrochemical_devices_manager.dart';
import 'package:utl_electrochemical_tester/adapter/local_storage/electrochemical_command_local_storage_handler.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_command_controller.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ConcreteElectrochemicalCommandController implements ElectrochemicalCommandController {
  final ElectrochemicalDevicesManager electrochemicalDevicesManager;
  final ElectrochemicalCommandLocalStorageHandler electrochemicalCommandLocalStorageHandler;
  ConcreteElectrochemicalCommandController({
    required this.electrochemicalDevicesManager,
    required this.electrochemicalCommandLocalStorageHandler,
  });

  @override
  Ad5940ParametersElectrochemicalWorkingElectrode getAd5940ParametersElectrochemicalWorkingElectrode() {
    return electrochemicalCommandLocalStorageHandler.getAd5940ParametersElectrochemicalWorkingElectrode();
  }

  @override
  Ad5940ParametersHsTiaRTia getAd5940ParametersHsTiaRTia() {
    return electrochemicalCommandLocalStorageHandler.getAd5940ParametersHsTiaRTia();
  }

  @override
  String getCaElectrochemicalParametersEDc() {
    final temp = electrochemicalCommandLocalStorageHandler.getCaElectrochemicalParametersEDc();
    return (temp / 1e3).toString();
  }

  @override
  String getCaElectrochemicalParametersTInterval() {
    final temp = electrochemicalCommandLocalStorageHandler.getCaElectrochemicalParametersTInterval();
    return (temp / 1e3).toString();
  }

  @override
  String getCaElectrochemicalParametersTRun() {
    final temp = electrochemicalCommandLocalStorageHandler.getCaElectrochemicalParametersTRun();
    return (temp / 1e3).toString();
  }

  @override
  int getCommandTabIndexBuffer() {
    return electrochemicalCommandLocalStorageHandler.getCommandTabIndexBuffer();
  }

  @override
  String getCvElectrochemicalParametersEBegin() {
    final temp = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEBegin();
    return (temp / 1e3).toString();
  }

  @override
  String getCvElectrochemicalParametersEStep() {
    final temp = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEStep();
    return (temp / 1e3).toString();
  }

  @override
  String getCvElectrochemicalParametersEVertex1() {
    final temp = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEVertex1();
    return (temp / 1e3).toString();
  }

  @override
  String getCvElectrochemicalParametersEVertex2() {
    final temp = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEVertex2();
    return (temp / 1e3).toString();
  }

  @override
  String getCvElectrochemicalParametersNumberOfScans() {
    final temp = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersNumberOfScans();
    return temp.toString();
  }

  @override
  String getCvElectrochemicalParametersScanRate() {
    final temp = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersScanRate();
    return (temp / 1e3).toString();
  }

  @override
  String getDataNameBuffer() {
    return electrochemicalCommandLocalStorageHandler.getDataNameBuffer();
  }

  @override
  String getDpvElectrochemicalParametersEBegin() {
    final temp = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEBegin();
    return (temp / 1e3).toString();
  }

  @override
  String getDpvElectrochemicalParametersEEnd() {
    final temp = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEEnd();
    return (temp / 1e3).toString();
  }

  @override
  String getDpvElectrochemicalParametersEPulse() {
    final temp = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEPulse();
    return (temp / 1e3).toString();
  }

  @override
  String getDpvElectrochemicalParametersEStep() {
    final temp = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEStep();
    return (temp / 1e3).toString();
  }

  @override
  DpvElectrochemicalParametersInversionOption getDpvElectrochemicalParametersInversionOption() {
    return electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersInversionOption();
  }

  @override
  String getDpvElectrochemicalParametersScanRate() {
    final temp = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersScanRate();
    return (temp / 1e3).toString();
  }

  @override
  String getDpvElectrochemicalParametersTPulse() {
    final temp = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersTPulse();
    return (temp / 1e3).toString();
  }

  @override
  void setAd5940ParametersElectrochemicalWorkingElectrode(Ad5940ParametersElectrochemicalWorkingElectrode ad5940ParametersElectrochemicalWorkingElectrode) {
    electrochemicalCommandLocalStorageHandler.setAd5940ParametersElectrochemicalWorkingElectrode(ad5940ParametersElectrochemicalWorkingElectrode);
  }

  @override
  void setAd5940ParametersHsTiaRTia(Ad5940ParametersHsTiaRTia ad5940ParametersHsTiaRTia) {
    electrochemicalCommandLocalStorageHandler.setAd5940ParametersHsTiaRTia(ad5940ParametersHsTiaRTia);
  }

  @override
  void setCaElectrochemicalParametersEDc(String eDc) {
    final parsedValue = double.tryParse(eDc);
    if(parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCaElectrochemicalParametersEDc(intValue);
  }

  @override
  void setCaElectrochemicalParametersTInterval(String tInterval) {
    final parsedValue = double.tryParse(tInterval);
    if(parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCaElectrochemicalParametersTInterval(intValue);
  }

  @override
  void setCaElectrochemicalParametersTRun(String tRun) {
    final parsedValue = double.tryParse(tRun);
    if(parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCaElectrochemicalParametersTRun(intValue);
  }

  @override
  void setCommandTabIndexBuffer(int index) {
    electrochemicalCommandLocalStorageHandler.setCommandTabIndexBuffer(index);
  }

  @override
  void setCvElectrochemicalParametersEBegin(String eBegin) {
    final parsedValue = double.tryParse(eBegin);
    if(parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCvElectrochemicalParametersEBegin(intValue);
  }

  @override
  void setCvElectrochemicalParametersEStep(String eStep) {
    final parsedValue = double.tryParse(eStep);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCvElectrochemicalParametersEStep(intValue);
  }

  @override
  void setCvElectrochemicalParametersEVertex1(String eVertex1) {
    final parsedValue = double.tryParse(eVertex1);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCvElectrochemicalParametersEVertex1(intValue);
  }

  @override
  void setCvElectrochemicalParametersEVertex2(String eVertex2) {
    final parsedValue = double.tryParse(eVertex2);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCvElectrochemicalParametersEVertex2(intValue);
  }

  @override
  void setCvElectrochemicalParametersNumberOfScans(String numberOfScans) {
    final parsedValue = int.tryParse(numberOfScans);
    if (parsedValue == null) return;
    electrochemicalCommandLocalStorageHandler.setCvElectrochemicalParametersNumberOfScans(parsedValue);
  }

  @override
  void setCvElectrochemicalParametersScanRate(String scanRate) {
    final parsedValue = double.tryParse(scanRate);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setCvElectrochemicalParametersScanRate(intValue);
  }

  @override
  void setDataNameBuffer(String dataName) {
    electrochemicalCommandLocalStorageHandler.setDataNameBuffer(dataName);
  }

  @override
  void setDpvElectrochemicalParametersEBegin(String eBegin) {
    final parsedValue = double.tryParse(eBegin);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersEBegin(intValue);
  }

  @override
  void setDpvElectrochemicalParametersEEnd(String eEnd) {
    final parsedValue = double.tryParse(eEnd);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersEEnd(intValue);
  }

  @override
  void setDpvElectrochemicalParametersEPulse(String ePulse) {
    final parsedValue = double.tryParse(ePulse);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersEPulse(intValue);
  }

  @override
  void setDpvElectrochemicalParametersEStep(String eStep) {
    final parsedValue = double.tryParse(eStep);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersEStep(intValue);
  }

  @override
  void setDpvElectrochemicalParametersInversionOption(DpvElectrochemicalParametersInversionOption inversionOption) {
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersInversionOption(inversionOption);
  }

  @override
  void setDpvElectrochemicalParametersScanRate(String scanRate) {
    final parsedValue = double.tryParse(scanRate);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersScanRate(intValue);
  }

  @override
  void setDpvElectrochemicalParametersTPulse(String tPulse) {
    final parsedValue = double.tryParse(tPulse);
    if (parsedValue == null) return;
    final intValue = (parsedValue * 1e3).toInt();
    electrochemicalCommandLocalStorageHandler.setDpvElectrochemicalParametersTPulse(intValue);
  }

  @override
  Future<void> start({required ElectrochemicalType type}) async {
    for(var device in electrochemicalDevicesManager.devices.toList()) {
      switch (type) {
        case ElectrochemicalType.ca:
          final eDc = electrochemicalCommandLocalStorageHandler.getCaElectrochemicalParametersEDc();
          final tInterval = electrochemicalCommandLocalStorageHandler.getCaElectrochemicalParametersTInterval();
          final tRun = electrochemicalCommandLocalStorageHandler.getCaElectrochemicalParametersTRun();
          await device.startCa(
            dto: CaElectrochemicalDeviceSentDto(
              ad5940Parameters: Ad5940Parameters(
                workingElectrode: getAd5940ParametersElectrochemicalWorkingElectrode(),
                // hsTiaRTia: getAd5940ParametersHsTiaRTia(),
              ),
              dataName: getDataNameBuffer(),
              electrochemicalParameters: CaElectrochemicalParameters(
                eDc: eDc,
                tInterval: tInterval,
                tRun: tRun,
              ),
            ),
          );
          break;
        case ElectrochemicalType.cv:
          final eBegin = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEBegin();
          final eVertex1 = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEVertex1();
          final eVertex2 = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEVertex2();
          final eStep = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersEStep();
          final scanRate = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersScanRate();
          final numberOfScans = electrochemicalCommandLocalStorageHandler.getCvElectrochemicalParametersNumberOfScans();
          await device.startCv(
            dto: CvElectrochemicalDeviceSentDto(
              ad5940Parameters: Ad5940Parameters(
                workingElectrode: getAd5940ParametersElectrochemicalWorkingElectrode(),
                // hsTiaRTia: getAd5940ParametersHsTiaRTia(),
              ),
              dataName: getDataNameBuffer(),
              electrochemicalParameters: CvElectrochemicalParameters(
                eBegin: eBegin,
                eVertex1: eVertex1,
                eVertex2: eVertex2,
                eStep: eStep,
                scanRate: scanRate,
                numberOfScans: numberOfScans,
              ),
            ),
          );
          break;
        case ElectrochemicalType.dpv:
          final eBegin = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEBegin();
          final eEnd = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEEnd();
          final eStep = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEStep();
          final ePulse = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersEPulse();
          final tPulse = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersTPulse();
          final scanRate = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersScanRate();
          final inversionOption = electrochemicalCommandLocalStorageHandler.getDpvElectrochemicalParametersInversionOption();
          await device.startDpv(
            dto: DpvElectrochemicalDeviceSentDto(
              ad5940Parameters: Ad5940Parameters(
                workingElectrode: getAd5940ParametersElectrochemicalWorkingElectrode(),
                // hsTiaRTia: getAd5940ParametersHsTiaRTia(),
              ),
              dataName: getDataNameBuffer(),
              electrochemicalParameters: DpvElectrochemicalParameters(
                eBegin: eBegin,
                eEnd: eEnd,
                eStep: eStep,
                ePulse: ePulse,
                tPulse: tPulse,
                scanRate: scanRate,
                inversionOption: inversionOption,
              ),
            ),
          );
          break;
      }
    }
  }
}
