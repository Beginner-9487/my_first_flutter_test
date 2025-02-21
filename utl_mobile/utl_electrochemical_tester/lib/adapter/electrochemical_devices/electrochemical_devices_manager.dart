import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/electrochemical_device_sent_dto.dart';

abstract class ElectrochemicalDevice {
  String get deviceId;
  Future<bool> startCa({
    required CaElectrochemicalDeviceSentDto dto,
  });
  Future<bool> startCv({
    required CvElectrochemicalDeviceSentDto dto,
  });
  Future<bool> startDpv({
    required DpvElectrochemicalDeviceSentDto dto,
  });
}

abstract class ElectrochemicalDevicesManager {
  Stream<ElectrochemicalDeviceReceivedHeaderDto> get headerStream;
  Stream<ElectrochemicalDeviceReceivedDataDto> get dataStream;
  Iterable<ElectrochemicalDevice> get devices;
}
