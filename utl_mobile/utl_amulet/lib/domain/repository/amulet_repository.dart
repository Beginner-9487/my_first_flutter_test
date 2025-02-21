import 'package:utl_amulet/domain/entity/amulet_entity.dart';

class AmuletRepositoryInsertDto {
  final String deviceId;
  final DateTime time;
  final int accX;
  final int accY;
  final int accZ;
  final int accTotal;
  // final int gyroX;
  // final int gyroY;
  // final int gyroZ;
  // final int gyroTotal;
  final int magX;
  final int magY;
  final int magZ;
  final int magTotal;
  final int pitch;
  final int roll;
  final int yaw;
  // final int gValue;
  final double pressure;
  final int temperature;
  final AmuletPostureType posture;
  final int adc;
  final int battery;
  final int area;
  final int step;
  final int direction;

  AmuletRepositoryInsertDto({
    required this.deviceId,
    required this.time,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.accTotal,
    // required this.gyroX,
    // required this.gyroY,
    // required this.gyroZ,
    // required this.gyroTotal,
    required this.magX,
    required this.magY,
    required this.magZ,
    required this.magTotal,
    required this.pitch,
    required this.roll,
    required this.yaw,
    // required this.gValue,
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

abstract class AmuletRepository {
  Stream<AmuletEntity> get entitySyncStream;
  Stream<int> get entityIdRemovedStream;
  Stream<AmuletEntity> fetchEntities();
  Future<bool> insert({
    required AmuletRepositoryInsertDto dto,
  });
  Future<bool> upsert({
    required AmuletEntity entity,
  });
  Future<bool> delete({
    required int entityId,
  });
  Future<bool> clear();
}
