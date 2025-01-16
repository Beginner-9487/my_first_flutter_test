import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';

abstract class ElectrochemicalSensor {
  String get deviceId;
  set dataName(String dataName);
  String get dataName;
  String get deviceName;
  Future startCa(CaSentPacket packet);
  Future startCv(CvSentPacket packet);
  Future startDpv(DpvSentPacket packet);
}

class ConcreteElectrochemicalSensor extends UtlBluetoothDevice implements ElectrochemicalSensor {
  ConcreteElectrochemicalSensor({
    required super.bluetoothDevice,
    required super.resource,
    required this.dataName,
  });

  @override
  String dataName;

  @override
  String get deviceName => bluetoothDevice.platformName;

  @override
  String get deviceId => bluetoothDevice.remoteId.str;

  @override
  Future startCa(CaSentPacket packet) async {
    write(packet.data);
  }

  @override
  Future startCv(CvSentPacket packet) async {
    write(packet.data);
  }

  @override
  Future startDpv(DpvSentPacket packet) async {
    write(packet.data);
  }
}