import 'package:hive/hive.dart';

part 'hive_amulet.g.dart';

@HiveType(typeId: 0)
enum HiveAmuletPostureType {
  @HiveField(0)
  init,
  @HiveField(1)
  seating,
  @HiveField(2)
  standing,
  @HiveField(3)
  supine,
  @HiveField(4)
  rightLateralDecubitus,
  @HiveField(5)
  leftLateralDecubitus,
  @HiveField(6)
  prone,
  @HiveField(7)
  falling,
  @HiveField(8)
  walking,
}

@HiveType(typeId: 1)
class HiveAmuletEntity extends HiveObject {
  @HiveField(0)
  final String deviceId;

  @HiveField(1)
  final DateTime time;

  @HiveField(2)
  final int accX;

  @HiveField(3)
  final int accY;

  @HiveField(4)
  final int accZ;

  @HiveField(5)
  final int accTotal;

  @HiveField(6)
  final int magX;

  @HiveField(7)
  final int magY;

  @HiveField(8)
  final int magZ;

  @HiveField(9)
  final int magTotal;

  @HiveField(10)
  final int pitch;

  @HiveField(11)
  final int roll;

  @HiveField(12)
  final int yaw;

  @HiveField(13)
  final double pressure;

  @HiveField(14)
  final int temperature;

  @HiveField(15)
  final HiveAmuletPostureType posture;

  @HiveField(16)
  final int adc;

  @HiveField(17)
  final int battery;

  @HiveField(18)
  final int area;

  @HiveField(19)
  final int step;

  @HiveField(20)
  final int direction;

  HiveAmuletEntity({
    required this.deviceId,
    required this.time,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.accTotal,
    required this.magX,
    required this.magY,
    required this.magZ,
    required this.magTotal,
    required this.pitch,
    required this.roll,
    required this.yaw,
    required this.pressure,
    required this.temperature,
    required this.posture,
    required this.adc,
    required this.battery,
    required this.area,
    required this.step,
    required this.direction,
  });
}
