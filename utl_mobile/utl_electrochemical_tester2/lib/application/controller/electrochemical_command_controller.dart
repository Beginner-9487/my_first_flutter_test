import 'dart:async';

import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_service.dart';

abstract class ElectrochemicalCommandController<CommandDevice> {
  Iterable<CommandDevice> get devices;
  Future<void> startCa(CaSentPacket packet);
  Future<void> startCv(CvSentPacket packet);
  Future<void> startDpv(DpvSentPacket packet);
  Future<void> setName(CommandDevice device, String name);
  Future<String> getName(CommandDevice device);
}

class ConcreteElectrochemicalCommandController implements ElectrochemicalCommandController<BluetoothDevice> {
  final BluetoothDevicesService service;
  ConcreteElectrochemicalCommandController({
    required this.service,
  });
  @override
  Iterable<BluetoothDevice> get devices => service.devices;
  @override
  Future<void> startCa(CaSentPacket packet) async {
    service.startCa(packet);
    return;
  }
  @override
  Future<void> startCv(CvSentPacket packet) async {
    service.startCv(packet);
    return;
  }
  @override
  Future<void> startDpv(DpvSentPacket packet) async {
    service.startDpv(packet);
    return;
  }
  @override
  Future<void> setName(BluetoothDevice device, String name) async {
    service.devices.where((d) => d == device).firstOrNull?.dataName = name;
    return;
  }
  @override
  Future<String> getName(BluetoothDevice device) async {
    return service.devices.where((d) => d == device).firstOrNull?.dataName ?? "";
  }
}
