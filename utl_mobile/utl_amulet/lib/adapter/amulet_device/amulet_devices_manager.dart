import 'package:utl_amulet/adapter/amulet_device/dto/amulet_device_data_dto.dart';

abstract class AmuletDevicesManager {
  Stream<AmuletDeviceDataDto> get dataStream;
  Stream<void> get clearStream;
  Iterable<AmuletDeviceDataDto> get dtoBuffer;
  Stream<Iterable<AmuletDeviceDataDto>> get dtoBufferSyncStream;
  void clearBuffer();
}
