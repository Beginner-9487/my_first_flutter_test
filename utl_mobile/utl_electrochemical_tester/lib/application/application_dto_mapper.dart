import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_header.dart';

class ApplicationDtoMapper {
  ApplicationDtoMapper._();
  static ElectrochemicalHeader mapDtoToHeader({
    required ElectrochemicalDeviceReceivedHeaderDto dto,
  }) {
    return ElectrochemicalHeader(dataName: dto.dataName, deviceId: dto.deviceId, createdTime: dto.createdTime, temperature: dto.temperature, parameters: dto.parameters);
  }
  static ElectrochemicalData mapDtoToData({
    required ElectrochemicalDeviceReceivedDataDto dto,
  }) {
    return ElectrochemicalData(index: dto.index, time: dto.time, voltage: dto.voltage, current: dto.current);
  }
}
