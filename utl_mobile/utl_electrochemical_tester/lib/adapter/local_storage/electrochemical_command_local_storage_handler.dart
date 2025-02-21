import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

abstract class ElectrochemicalCommandLocalStorageHandler {
  void setCommandTabIndexBuffer(int index);
  int getCommandTabIndexBuffer();

  void setDataNameBuffer(String dataName);
  String getDataNameBuffer();

  void setAd5940ParametersElectrochemicalWorkingElectrode(Ad5940ParametersElectrochemicalWorkingElectrode ad5940ParametersElectrochemicalWorkingElectrode);
  Ad5940ParametersElectrochemicalWorkingElectrode getAd5940ParametersElectrochemicalWorkingElectrode();

  void setAd5940ParametersHsTiaRTia(Ad5940ParametersHsTiaRTia ad5940ParametersHsTiaRTia);
  Ad5940ParametersHsTiaRTia getAd5940ParametersHsTiaRTia();

  void setCaElectrochemicalParametersEDc(int eDc);
  int getCaElectrochemicalParametersEDc();

  void setCaElectrochemicalParametersTInterval(int tInterval);
  int getCaElectrochemicalParametersTInterval();

  void setCaElectrochemicalParametersTRun(int tRun);
  int getCaElectrochemicalParametersTRun();

  void setCvElectrochemicalParametersEBegin(int eBegin);
  int getCvElectrochemicalParametersEBegin();

  void setCvElectrochemicalParametersEVertex1(int eVertex1);
  int getCvElectrochemicalParametersEVertex1();

  void setCvElectrochemicalParametersEVertex2(int eVertex2);
  int getCvElectrochemicalParametersEVertex2();

  void setCvElectrochemicalParametersEStep(int eStep);
  int getCvElectrochemicalParametersEStep();

  void setCvElectrochemicalParametersScanRate(int scanRate);
  int getCvElectrochemicalParametersScanRate();

  void setCvElectrochemicalParametersNumberOfScans(int numberOfScans);
  int getCvElectrochemicalParametersNumberOfScans();

  void setDpvElectrochemicalParametersEBegin(int eBegin);
  int getDpvElectrochemicalParametersEBegin();

  void setDpvElectrochemicalParametersEEnd(int eEnd);
  int getDpvElectrochemicalParametersEEnd();

  void setDpvElectrochemicalParametersEStep(int eStep);
  int getDpvElectrochemicalParametersEStep();

  void setDpvElectrochemicalParametersEPulse(int ePulse);
  int getDpvElectrochemicalParametersEPulse();

  void setDpvElectrochemicalParametersTPulse(int tPulse);
  int getDpvElectrochemicalParametersTPulse();

  void setDpvElectrochemicalParametersScanRate(int scanRate);
  int getDpvElectrochemicalParametersScanRate();

  void setDpvElectrochemicalParametersInversionOption(DpvElectrochemicalParametersInversionOption inversionOption);
  DpvElectrochemicalParametersInversionOption getDpvElectrochemicalParametersInversionOption();
}