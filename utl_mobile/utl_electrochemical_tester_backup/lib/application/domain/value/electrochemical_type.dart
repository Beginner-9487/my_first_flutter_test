import 'package:hive_flutter/adapters.dart';

part 'electrochemical_type.g.dart';

@HiveType(typeId: 40)
enum ElectrochemicalType {
  @HiveField(0)
  ca,
  @HiveField(1)
  cv,
  @HiveField(2)
  dpv,
}