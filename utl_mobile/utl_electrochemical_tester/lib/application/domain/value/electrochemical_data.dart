import 'package:hive_flutter/adapters.dart';

part 'electrochemical_data.g.dart';

@HiveType(typeId: 10)
class ElectrochemicalData {
  @HiveField(0)
  final int index;
  @HiveField(1)
  final int time;
  @HiveField(2)
  final int voltage;
  @HiveField(3)
  final int current;
  ElectrochemicalData({
    required this.index,
    required this.time,
    required this.voltage,
    required this.current,
  });
}