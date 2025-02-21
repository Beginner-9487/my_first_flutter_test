import 'package:utl_amulet/domain/entity/amulet_entity.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';

import 'hive_amulet.dart';

class HiveAmuletMapper {
  HiveAmuletMapper._();

  static HiveAmuletEntity fromAmuletRepositoryInsertDto({
    required AmuletRepositoryInsertDto dto,
  }) {
    return HiveAmuletEntity(
      deviceId: dto.deviceId,
      time: dto.time,
      accX: dto.accX,
      accY: dto.accY,
      accZ: dto.accZ,
      accTotal: dto.accTotal,
      magX: dto.magX,
      magY: dto.magY,
      magZ: dto.magZ,
      magTotal: dto.magTotal,
      pitch: dto.pitch,
      roll: dto.roll,
      yaw: dto.yaw,
      pressure: dto.pressure,
      temperature: dto.temperature,
      posture: HiveAmuletPostureType.values[dto.posture.index],
      adc: dto.adc,
      battery: dto.battery,
      area: dto.area,
      step: dto.step,
      direction: dto.direction,
    );
  }

  static HiveAmuletEntity fromAmuletEntity({
    required AmuletEntity entity,
  }) {
    return HiveAmuletEntity(
      deviceId: entity.deviceId,
      time: entity.time,
      accX: entity.accX,
      accY: entity.accY,
      accZ: entity.accZ,
      accTotal: entity.accTotal,
      magX: entity.magX,
      magY: entity.magY,
      magZ: entity.magZ,
      magTotal: entity.magTotal,
      pitch: entity.pitch,
      roll: entity.roll,
      yaw: entity.yaw,
      pressure: entity.pressure,
      temperature: entity.temperature,
      posture: HiveAmuletPostureType.values[entity.posture.index],
      adc: entity.adc,
      battery: entity.battery,
      area: entity.area,
      step: entity.step,
      direction: entity.direction,
    );
  }

  static AmuletEntity toAmuletEntity({
    required int id,
    required HiveAmuletEntity entity,
  }) {
    return AmuletEntity(
      id: id,
      deviceId: entity.deviceId,
      time: entity.time,
      accX: entity.accX,
      accY: entity.accY,
      accZ: entity.accZ,
      accTotal: entity.accTotal,
      magX: entity.magX,
      magY: entity.magY,
      magZ: entity.magZ,
      magTotal: entity.magTotal,
      pitch: entity.pitch,
      roll: entity.roll,
      yaw: entity.yaw,
      pressure: entity.pressure,
      temperature: entity.temperature,
      posture: AmuletPostureType.values[entity.posture.index],
      adc: entity.adc,
      battery: entity.battery,
      area: entity.area,
      step: entity.step,
      direction: entity.direction,
    );
  }
}
