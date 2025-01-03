import 'dart:typed_data';

import 'package:utl_electrochemical_tester/application/data/electrochemical_parameters.dart';

abstract class Packet {
  Uint8List get data;
}

class CaSentPacket extends Packet {
  CaSentPacket({
    required this.parameters
  });

  CaElectrochemicalParameters parameters;

  @override
  // TODO: implement data
  Uint8List get data => throw UnimplementedError();
}

class CvSentPacket extends Packet {
  CvSentPacket({
    required this.parameters
  });

  CvElectrochemicalParameters parameters;

  @override
  // TODO: implement data
  Uint8List get data => throw UnimplementedError();
}

class DpvSentPacket extends Packet {
  DpvSentPacket({
    required this.parameters
  });

  DpvElectrochemicalParameters parameters;

  @override
  // TODO: implement data
  Uint8List get data => throw UnimplementedError();
}
