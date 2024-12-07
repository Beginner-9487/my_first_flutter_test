import 'dart:async';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:flutter_utility/bt_packet_recorder.dart';

class BT_Packet_Recorder_Impl implements BT_Packet_Recorder {
  BT_Packet_Recorder_Impl({
    required this.provider,
    required this.handler,
    required this.path,
    bool Function(BT_Device device)? deviceFilter,
    bool Function(BT_Service service)? serviceFilter,
    bool Function(BT_Characteristic characteristic)? characteristicFilter,
    bool Function(BT_Descriptor descriptor)? descriptorFilter,
  }) {
    _deviceFilter = (deviceFilter != null) ? deviceFilter : (device) => true;
    _serviceFilter = (serviceFilter != null) ? serviceFilter : (service) => true;
    _characteristicFilter = (characteristicFilter != null) ? characteristicFilter : (characteristic) => true;
    _descriptorFilter = (descriptorFilter != null) ? descriptorFilter : (descriptor) => true;
  }
  BT_Provider provider;
  RowCSVFileHandler handler;
  SystemPath path;
  late final bool Function(BT_Device device) _deviceFilter;
  late final bool Function(BT_Service service) _serviceFilter;
  late final bool Function(BT_Characteristic characteristic) _characteristicFilter;
  late final bool Function(BT_Descriptor descriptor) _descriptorFilter;
  DateTime get currentTime => DateTime.now();
  final String _EXTENSION = "csv";
  String get fileName => "BT_Packet_Record"
      "_${currentTime.year}"
      "-${currentTime.month}"
      "-${currentTime.day}"
      "-${currentTime.hour}"
      "-${currentTime.minute}"
      "-${currentTime.second}"
      "-${currentTime.millisecond}"
      "-${currentTime.microsecond}";
  String get fileDirectory => path.system_download_path_absolute;
  String get filePath => '$fileDirectory/$fileName.$_EXTENSION';
  late RowCSVFile file;
  void write(BT_Packet packet) {
    file.write([
      currentTime.toString(),
      ...packet
          .bytes
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .toList(),
    ]);
  }
  final List<StreamSubscription> onReceivePacket = [];
  @override
  void createFile() {
    handler.createEmptyFile(filePath).then((value) {
      file = value;
      for (var device in provider.devices.where((element) => _deviceFilter(element))) {
        for (var service in device.services.where((element) => _serviceFilter(element))) {
          for (var characteristic in service.characteristics.where((element) => _characteristicFilter(element))) {
            onReceivePacket.add(characteristic.onReceiveAllPacket(write));
            for (var descriptor in characteristic.descriptors.where((element) => _descriptorFilter(element))) {
              onReceivePacket.add(descriptor.onReceiveAllPacket(write));
            }
          }
        }
      }
    });
  }
  @override
  void finish() {
    for (var element in onReceivePacket) {
      element.cancel();
    }
    onReceivePacket.clear();
  }
}