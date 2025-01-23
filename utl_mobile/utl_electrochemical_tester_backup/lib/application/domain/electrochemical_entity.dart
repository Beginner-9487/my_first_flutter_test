import 'package:equatable/equatable.dart';
import 'package:flutter_basic_utils/basic/general_utils.dart';
import 'package:flutter_basic_utils/presentation/dataset_color_generator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_header.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_type.dart';
import 'package:utl_electrochemical_tester/application/dto/electrochemical_file_dto.dart';
import 'package:utl_electrochemical_tester/application/dto/electrochemical_ui_dto.dart';

part 'electrochemical_entity.g.dart';

@HiveType(typeId: 00)
class ElectrochemicalEntity extends ElectrochemicalHeader with EquatableMixin {

  ElectrochemicalEntity({
    required this.id,
    required super.dataName,
    required super.deviceId,
    required super.createdTime,
    required super.temperature,
    required super.parameters,
    required this.data,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final List<ElectrochemicalData> data;

  /// Calculate average current
  int get averageCurrent => data.isEmpty
      ? 0
      : data.map((d) => d.current).reduce((value, element) => value + element) ~/ data.length;

  /// Calculate maximum current
  int get maxCurrent => data.isEmpty ? 0 : data.map((d) => d.current).reduce((a, b) => a > b ? a : b);

  /// Calculate minimum current
  int get minCurrent => data.isEmpty ? 0 : data.map((d) => d.current).reduce((a, b) => a < b ? a : b);

  ElectrochemicalFileDto get fileDto => ElectrochemicalFileDto(
    id: id.toString(),
    dataName: dataName,
    deviceId: deviceId,
    createdTime: DateTime.fromMicrosecondsSinceEpoch(createdTime).toIso8601String(),
    type: type.name,
    temperature: temperature.toString(),
    caEDc: parameters is CaElectrochemicalParameters
        ? (parameters as CaElectrochemicalParameters).eDc.toString()
        : "",
    caTInterval: parameters is CaElectrochemicalParameters
        ? (parameters as CaElectrochemicalParameters).tInterval.toString()
        : "",
    caTRun: parameters is CaElectrochemicalParameters
        ? (parameters as CaElectrochemicalParameters).tRun.toString()
        : "",
    cvEBegin: parameters is CvElectrochemicalParameters
        ? (parameters as CvElectrochemicalParameters).eBegin.toString()
        : "",
    cvEVertex1: parameters is CvElectrochemicalParameters
        ? (parameters as CvElectrochemicalParameters).eVertex1.toString()
        : "",
    cvEVertex2: parameters is CvElectrochemicalParameters
        ? (parameters as CvElectrochemicalParameters).eVertex2.toString()
        : "",
    cvEStep: parameters is CvElectrochemicalParameters
        ? (parameters as CvElectrochemicalParameters).eStep.toString()
        : "",
    cvScanRate: parameters is CvElectrochemicalParameters
        ? (parameters as CvElectrochemicalParameters).scanRate.toString()
        : "",
    cvNumberOfScans: parameters is CvElectrochemicalParameters
        ? (parameters as CvElectrochemicalParameters).numberOfScans.toString()
        : "",
    dpvEBegin: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).eBegin.toString()
        : "",
    dpvEEnd: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).eEnd.toString()
        : "",
    dpvEStep: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).eStep.toString()
        : "",
    dpvEPulse: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).ePulse.toString()
        : "",
    dpvTPulse: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).tPulse.toString()
        : "",
    dpvScanRate: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).scanRate.toString()
        : "",
    dpvInversionOption: parameters is DpvElectrochemicalParameters
        ? (parameters as DpvElectrochemicalParameters).inversionOption.name
        : "",
    data: data.map((e) => e.current.toDouble()).toList(),
  );

  ElectrochemicalUiDto uiDto({
    required int dataStartIndex,
    required int dataLength,
    required int entitiesIndex,
    required int entitiesLength,
  }) {
    return ElectrochemicalUiDto(
      color: DatasetColorGenerator.rainbowGroup(
        alpha: 1,
        index: entitiesIndex + 10,
        length: entitiesLength + 10,
        groupIndex: ElectrochemicalType.values.indexOf(type),
        groupLength: ElectrochemicalType.values.length,
      ),
      createdTime: DateTime.fromMicrosecondsSinceEpoch(createdTime),
      data: data
        .skip(dataStartIndex)
        .take(dataLength)
        .map((e) => ElectrochemicalUiDtoData(
          index: e.index,
          time: (e.time / 1E3).toPrecision(3),
          voltage: (e.voltage / 1E3).toPrecision(3),
          current: (e.current / 1E3).toPrecision(3),
        )).toList(),
      dataName: dataName,
      deviceId: deviceId,
      type: type,
      temperature: (temperature / 1E6).toPrecision(6),
    );
  }

  @override
  List<Object?> get props => [id];
}