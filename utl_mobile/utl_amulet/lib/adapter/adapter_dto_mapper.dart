import 'package:utl_amulet/adapter/amulet_device/dto/amulet_device_data_dto.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';
import 'package:utl_amulet/domain/repository/amulet_repository.dart';

class AdapterDtoMapper {
  AdapterDtoMapper._();
  static AmuletRepositoryInsertDto mapDeviceDataDtoToRepositoryInsertDto({
    required AmuletDeviceDataDto dto,
  }) {
    return AmuletRepositoryInsertDto(
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
      posture: dto.posture,
      adc: dto.adc,
      battery: dto.battery,
      area: dto.area,
      step: dto.step,
      direction: dto.direction,
    );
  }
  static AmuletDeviceDataDto mapEntityToRepositoryInsertDto({
    required AmuletEntity entity,
  }) {
    return AmuletDeviceDataDto(
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
      posture: entity.posture,
      adc: entity.adc,
      battery: entity.battery,
      area: entity.area,
      step: entity.step,
      direction: entity.direction,
    );
  }
}
