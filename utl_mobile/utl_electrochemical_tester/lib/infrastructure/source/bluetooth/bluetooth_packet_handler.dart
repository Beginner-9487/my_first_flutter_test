import 'package:utl_electrochemical_tester/adapter/dto/electrochemical_device_received_dto.dart';
import 'package:utl_electrochemical_tester/infrastructure/source/bluetooth/bluetooth_received_packet.dart';

abstract class BluetoothPacketHandler {
  void handleReceivedPacket({
    required BluetoothReceivedPacket packet,
  });
  Stream<ElectrochemicalDeviceReceivedHeaderDto> get electrochemicalHeaderStream;
  Stream<ElectrochemicalDeviceReceivedDataDto> get electrochemicalDataStream;
}
