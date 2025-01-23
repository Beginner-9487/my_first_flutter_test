import 'dart:typed_data';

import 'package:utl_electrochemical_tester/adapter/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/adapter/dto/electrochemical_device_sent_dto.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class BluetoothSentPacket {
  Uint8List data;
  BluetoothSentPacket({
    required this.data,
  });
  @override
  String toString() {
    return "BluetoothSentPacket: "
        "\n\tdata: $data"
    ;
  }
  static ByteData _mapAD5940ParametersToByteData({
    required Ad5940Parameters parameters,
  }) {
    return ByteData(4)
      ..setUint32(0, parameters.hsTiaRTia.index, Endian.little);
  }
  static ByteData _mapCaElectrochemicalParametersToByteData({
    required CaElectrochemicalParameters parameters,
  }) {
    return ByteData(8)
      ..setUint16(0, parameters.tInterval, Endian.little)
      ..setInt16(2, parameters.eDc, Endian.little)
      ..setUint32(4, parameters.tRun, Endian.little);
  }
  static ByteData _mapCvElectrochemicalParametersToByteData({
    required CvElectrochemicalParameters parameters,
  }) {
    return ByteData(11)
      ..setUint32(0, parameters.numberOfScans, Endian.little)
      ..setInt16(1, parameters.eBegin, Endian.little)
      ..setInt16(3, parameters.eVertex1, Endian.little)
      ..setInt16(5, parameters.eVertex2, Endian.little)
      ..setUint16(7, parameters.eStep, Endian.little)
      ..setUint16(9, parameters.scanRate, Endian.little);
  }
  static ByteData _mapDpvElectrochemicalParametersToByteData({
    required DpvElectrochemicalParameters parameters,
  }) {
    return ByteData(13)
      ..setInt16(0, parameters.eBegin, Endian.little)
      ..setInt16(2, parameters.eEnd, Endian.little)
      ..setUint16(4, parameters.eStep, Endian.little)
      ..setUint16(6, parameters.ePulse, Endian.little)
      ..setUint16(8, parameters.tPulse, Endian.little)
      ..setUint16(10, parameters.scanRate, Endian.little)
      ..setUint8(12, parameters.inversionOption.index);
  }
  static BluetoothSentPacket fromCa({
    required CaElectrochemicalDeviceSentDto dto,
  }) {
    return BluetoothSentPacket(
      data: Uint8List.fromList([
        0x01,
        dto.electrochemicalParameters.type.index,
        ..._mapAD5940ParametersToByteData(parameters: dto.ad5940Parameters).buffer.asUint8List(),
        ..._mapCaElectrochemicalParametersToByteData(parameters: dto.electrochemicalParameters).buffer.asUint8List(),
      ]),
    );
  }
  static BluetoothSentPacket fromCv({
    required CvElectrochemicalDeviceSentDto dto,
  }) {
    return BluetoothSentPacket(
      data: Uint8List.fromList([
        0x01,
        dto.electrochemicalParameters.type.index,
        ..._mapAD5940ParametersToByteData(parameters: dto.ad5940Parameters).buffer.asUint8List(),
        ..._mapCvElectrochemicalParametersToByteData(parameters: dto.electrochemicalParameters).buffer.asUint8List(),
      ]),
    );
  }
  static BluetoothSentPacket fromDpv({
    required DpvElectrochemicalDeviceSentDto dto,
  }) {
    return BluetoothSentPacket(
      data: Uint8List.fromList([
        0x01,
        dto.electrochemicalParameters.type.index,
        ..._mapAD5940ParametersToByteData(parameters: dto.ad5940Parameters).buffer.asUint8List(),
        ..._mapDpvElectrochemicalParametersToByteData(parameters: dto.electrochemicalParameters).buffer.asUint8List(),
      ]),
    );
  }
}
