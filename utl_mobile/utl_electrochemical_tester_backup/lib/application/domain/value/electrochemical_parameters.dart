import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';

part 'electrochemical_parameters.g.dart';

abstract class ElectrochemicalParameters {
  Uint8List get data;
  ElectrochemicalType get type;
}

@HiveType(typeId: 30)
class CaElectrochemicalParameters extends ElectrochemicalParameters {
  @HiveField(0)
  final int eDc;
  @HiveField(1)
  final int tInterval;
  @HiveField(2)
  final int tRun;

  CaElectrochemicalParameters({
    required this.eDc,
    required this.tInterval,
    required this.tRun,
  });

  @override
  ElectrochemicalType get type => ElectrochemicalType.ca;

  @override
  Uint8List get data {
    final byteData = ByteData(8); // 2 (ADC_sample_interval) + 2 (E_dc) + 4 (FIFO_thresh)

    // Write the parameters to the byte buffer in the same order as in the struct
    byteData.setUint16(0, tInterval, Endian.little); // ADC_sample_interval
    byteData.setInt16(2, eDc, Endian.little);        // E_dc
    byteData.setUint32(4, tRun, Endian.little);      // FIFO_thresh

    return byteData.buffer.asUint8List();
  }
}

@HiveType(typeId: 31)
class CvElectrochemicalParameters extends ElectrochemicalParameters {
  @HiveField(0)
  final int eBegin;
  @HiveField(1)
  final int eVertex1;
  @HiveField(2)
  final int eVertex2;
  @HiveField(3)
  final int eStep;
  @HiveField(4)
  final int scanRate;
  @HiveField(5)
  final int numberOfScans;

  CvElectrochemicalParameters({
    required this.eBegin,
    required this.eVertex1,
    required this.eVertex2,
    required this.eStep,
    required this.scanRate,
    required this.numberOfScans,
  });

  @override
  ElectrochemicalType get type => ElectrochemicalType.cv;

  @override
  Uint8List get data {
    // Total size: 2 (E_begin) + 2 (E_vertex1) + 2 (E_vertex2) + 2 (E_step) + 2 (scan_rate) + 4 (numberOfScans) = 14 bytes
    final byteData = ByteData(11);

    // Write the parameters in the correct order
    byteData.setUint32(0, numberOfScans, Endian.little); // numberOfScans
    byteData.setInt16(1, eBegin, Endian.little);     // E_begin
    byteData.setInt16(3, eVertex1, Endian.little);  // E_vertex1
    byteData.setInt16(5, eVertex2, Endian.little);  // E_vertex2
    byteData.setUint16(7, eStep, Endian.little);    // E_step
    byteData.setUint16(9, scanRate, Endian.little); // scan_rate

    return byteData.buffer.asUint8List();
  }
}

@HiveType(typeId: 32)
class DpvElectrochemicalParameters extends ElectrochemicalParameters {
  @HiveField(0)
  final int eBegin;
  @HiveField(1)
  final int eEnd;
  @HiveField(2)
  final int eStep;
  @HiveField(3)
  final int ePulse;
  @HiveField(4)
  final int tPulse;
  @HiveField(5)
  final int scanRate;
  @HiveField(6)
  InversionOption inversionOption;

  DpvElectrochemicalParameters({
    required this.eBegin,
    required this.eEnd,
    required this.eStep,
    required this.ePulse,
    required this.tPulse,
    required this.scanRate,
    required this.inversionOption,
  });

  @override
  ElectrochemicalType get type => ElectrochemicalType.dpv;

  @override
  Uint8List get data {
    // Total size: 2 (E_begin) + 2 (E_end) + 2 (E_step) + 2 (E_pulse) +
    // 2 (t_pulse) + 2 (scan_rate) + 1 (inversion_option) = 13 bytes
    final byteData = ByteData(13);

    // Write the parameters in the correct order
    byteData.setInt16(0, eBegin, Endian.little);     // E_begin
    byteData.setInt16(2, eEnd, Endian.little);       // E_end
    byteData.setUint16(4, eStep, Endian.little);     // E_step
    byteData.setUint16(6, ePulse, Endian.little);    // E_pulse
    byteData.setUint16(8, tPulse, Endian.little);    // t_pulse
    byteData.setUint16(10, scanRate, Endian.little); // scan_rate
    byteData.setUint8(12, inversionOption.index);    // inversion_option

    return byteData.buffer.asUint8List();
  }
}

@HiveType(typeId: 33)
enum InversionOption {
  @HiveField(0)
  none,
  @HiveField(1)
  both,
  @HiveField(2)
  cathodic,
  @HiveField(3)
  anodic,
}