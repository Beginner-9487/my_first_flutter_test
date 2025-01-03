import 'dart:typed_data';

import 'package:utl_electrochemical_tester/application/domain/value/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

abstract class SentPacket {
  Uint8List get data;
}

abstract class ElectrochemicalSensorSentPacket implements SentPacket {
  ElectrochemicalParameters get electrochemicalParameters;
  AD5940Parameters get ad5940Parameters;
  @override
  Uint8List get data {
    final electrochemicalParametersData = electrochemicalParameters.data;
    final ad5940ParametersData = ad5940Parameters.data;
    final newData = Uint8List(2 + ad5940ParametersData.length + electrochemicalParameters.data.length);
    newData[0] = 0x01;
    newData[1] = electrochemicalParameters.type.index;
    newData.setRange(
      2,
      2 + ad5940ParametersData.length,
      ad5940ParametersData,
    );
    newData.setRange(
      2 + ad5940ParametersData.length,
      2 + ad5940ParametersData.length + electrochemicalParametersData.length,
      electrochemicalParametersData,
    );
    return newData;
  }
}

class CaSentPacket extends ElectrochemicalSensorSentPacket {
  CaSentPacket({
    required this.electrochemicalParameters,
    required this.ad5940Parameters,
  });

  @override
  CaElectrochemicalParameters electrochemicalParameters;

  @override
  AD5940Parameters ad5940Parameters;
}

class CvSentPacket extends ElectrochemicalSensorSentPacket {
  CvSentPacket({
    required this.electrochemicalParameters,
    required this.ad5940Parameters,
  });

  @override
  CvElectrochemicalParameters electrochemicalParameters;

  @override
  AD5940Parameters ad5940Parameters;
}

class DpvSentPacket extends ElectrochemicalSensorSentPacket {
  DpvSentPacket({
    required this.electrochemicalParameters,
    required this.ad5940Parameters,
  });

  @override
  DpvElectrochemicalParameters electrochemicalParameters;

  @override
  AD5940Parameters ad5940Parameters;
}
