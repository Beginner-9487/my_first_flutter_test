import 'package:equatable/equatable.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_header.dart';

class ElectrochemicalDataEntity extends ElectrochemicalHeader with EquatableMixin {

  ElectrochemicalDataEntity({
    required this.id,
    required super.dataName,
    required super.deviceId,
    required super.createdTime,
    required super.temperature,
    required super.parameters,
    required this.data,
  });

  final int id;

  final List<ElectrochemicalData> data;

  /// Calculate average current
  int get averageCurrent => data.isEmpty
      ? 0
      : data.map((d) => d.current).reduce((value, element) => value + element) ~/ data.length;

  /// Calculate maximum current
  int get maxCurrent => data.isEmpty ? 0 : data.map((d) => d.current).reduce((a, b) => a > b ? a : b);

  /// Calculate minimum current
  int get minCurrent => data.isEmpty ? 0 : data.map((d) => d.current).reduce((a, b) => a < b ? a : b);

  @override
  List<Object?> get props => [id];
}