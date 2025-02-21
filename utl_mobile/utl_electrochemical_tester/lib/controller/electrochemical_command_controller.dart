import 'dart:async';

import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

abstract class ElectrochemicalCommandController {
  Future<void> start({required ElectrochemicalType type});

  void setCommandTabIndexBuffer(int index);
  int getCommandTabIndexBuffer();

  void setDataNameBuffer(String dataName);
  String getDataNameBuffer();

  void setAd5940ParametersElectrochemicalWorkingElectrode(Ad5940ParametersElectrochemicalWorkingElectrode ad5940ParametersElectrochemicalWorkingElectrode);
  Ad5940ParametersElectrochemicalWorkingElectrode getAd5940ParametersElectrochemicalWorkingElectrode();

  void setAd5940ParametersHsTiaRTia(Ad5940ParametersHsTiaRTia ad5940ParametersHsTiaRTia);
  Ad5940ParametersHsTiaRTia getAd5940ParametersHsTiaRTia();

  void setCaElectrochemicalParametersEDc(String eDc);
  String getCaElectrochemicalParametersEDc();

  void setCaElectrochemicalParametersTInterval(String tInterval);
  String getCaElectrochemicalParametersTInterval();

  void setCaElectrochemicalParametersTRun(String tRun);
  String getCaElectrochemicalParametersTRun();

  void setCvElectrochemicalParametersEBegin(String eBegin);
  String getCvElectrochemicalParametersEBegin();

  void setCvElectrochemicalParametersEVertex1(String eVertex1);
  String getCvElectrochemicalParametersEVertex1();

  void setCvElectrochemicalParametersEVertex2(String eVertex2);
  String getCvElectrochemicalParametersEVertex2();

  void setCvElectrochemicalParametersEStep(String eStep);
  String getCvElectrochemicalParametersEStep();

  void setCvElectrochemicalParametersScanRate(String scanRate);
  String getCvElectrochemicalParametersScanRate();

  void setCvElectrochemicalParametersNumberOfScans(String numberOfScans);
  String getCvElectrochemicalParametersNumberOfScans();

  void setDpvElectrochemicalParametersEBegin(String eBegin);
  String getDpvElectrochemicalParametersEBegin();

  void setDpvElectrochemicalParametersEEnd(String eEnd);
  String getDpvElectrochemicalParametersEEnd();

  void setDpvElectrochemicalParametersEStep(String eStep);
  String getDpvElectrochemicalParametersEStep();

  void setDpvElectrochemicalParametersEPulse(String ePulse);
  String getDpvElectrochemicalParametersEPulse();

  void setDpvElectrochemicalParametersTPulse(String tPulse);
  String getDpvElectrochemicalParametersTPulse();

  void setDpvElectrochemicalParametersScanRate(String scanRate);
  String getDpvElectrochemicalParametersScanRate();

  void setDpvElectrochemicalParametersInversionOption(DpvElectrochemicalParametersInversionOption inversionOption);
  DpvElectrochemicalParametersInversionOption getDpvElectrochemicalParametersInversionOption();

}
