import 'dart:async';

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

class ConcreteElectrochemicalCommandController<CommandDevice> implements ElectrochemicalCommandController<CommandDevice> {
  static late final BluetoothDevicesService<BluetoothDevice> _service;
  static void init(BluetoothDevicesService<BluetoothDevice> service) {
    _service = service;
  }
  CommandDevice Function(BluetoothDevice serviceDevice) convertor;
  bool Function(BluetoothDevice serviceDevice, CommandDevice commandDevice) filter;
  ConcreteElectrochemicalCommandController({
    required this.convertor,
    required this.filter,
  });
  @override
  Iterable<CommandDevice> get devices => _service.devices.map(convertor);
  @override
  Future<void> startCa(CaSentPacket packet) async {
    for (var device in _service.devices) {
      device.startCa(packet);
    }
    return;
  }
  @override
  Future<void> startCv(CvSentPacket packet) async {
    for (var device in _service.devices) {
      device.startCv(packet);
    }
    return;
  }
  @override
  Future<void> startDpv(DpvSentPacket packet) async {
    for (var device in _service.devices) {
      device.startDpv(packet);
    }
    return;
  }
  @override
  Future<void> setName(CommandDevice device, String name) async {
    _service.devices.where((m) => filter(m, device)).firstOrNull?.dataName = name;
    return;
  }
  @override
  Future<String> getName(CommandDevice device) async {
    return _service.devices.where((m) => filter(m, device)).firstOrNull?.dataName ?? "";
  }
}
