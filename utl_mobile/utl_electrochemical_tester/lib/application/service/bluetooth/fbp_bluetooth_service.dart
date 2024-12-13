import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_service.dart' as my;

// Example classes for CaSentPacket, CvSentPacket, DpvSentPacket, HeaderReceivedPacket, and DataReceivedPacket.
// These should be replaced with your actual implementations.
class CaSentPacket {}
class CvSentPacket {}
class DpvSentPacket {}
class HeaderReceivedPacket {}
class DataReceivedPacket {}

class FlutterBluetoothDevice implements my.BluetoothDevice {
  final BluetoothDevice _device;
  final StreamController<HeaderReceivedPacket> _headerStreamController = StreamController.broadcast();
  final StreamController<DataReceivedPacket> _dataStreamController = StreamController.broadcast();

  String? _dataName;

  FlutterBluetoothDevice(this._device);

  @override
  String get id => _device.remoteId.str;

  @override
  String get dataName => _dataName ?? '';

  @override
  set dataName(String dataName) {
    _dataName = dataName;
  }

  @override
  String get deviceName => _device.name ?? '';

  @override
  Future connect() async {
    try {
      await _device.connect();
    } catch (e) {
      throw Exception('Failed to connect to device: $e');
    }
  }

  @override
  Future disconnect() async {
    try {
      await _device.disconnect();
    } catch (e) {
      throw Exception('Failed to disconnect from device: $e');
    }
  }

  @override
  Future startCa(CaSentPacket packet) async {
    // Logic to send the CaSentPacket to the device.
    // Replace with actual implementation.
  }

  @override
  Future startCv(CvSentPacket packet) async {
    // Logic to send the CvSentPacket to the device.
    // Replace with actual implementation.
  }

  @override
  Future startDpv(DpvSentPacket packet) async {
    // Logic to send the DpvSentPacket to the device.
    // Replace with actual implementation.
  }

  @override
  Stream<HeaderReceivedPacket> get onReceiveHeaderPacket => _headerStreamController.stream;

  @override
  Stream<DataReceivedPacket> get onReceivedDataPacket => _dataStreamController.stream;

  void _processIncomingData(dynamic rawData) {
    // Parse rawData to generate HeaderReceivedPacket or DataReceivedPacket.
    // Add to appropriate stream controllers.
    // Example:
    // var headerPacket = HeaderReceivedPacket.fromRawData(rawData);
    // _headerStreamController.add(headerPacket);
  }
}

class FbpBluetoothDevice implements my.BluetoothDevice {
  
}

class FbpBluetoothDevicesService<FbpBluetoothDevice> {
  Iterable<BluetoothDevice> Function() getDevices;
  FbpBluetoothDevice Function(BluetoothDevice device) deviceConvertor;
  FbpBluetoothDevice Function(ScanResult device) scanResultConvertor;
  FbpBluetoothDevicesService({
    required this.getDevices,
    required this.deviceConvertor,
    required this.scanResultConvertor,
  });
  Iterable<FbpBluetoothDevice> get devices => getDevices().map(deviceConvertor);
  Stream<FbpBluetoothDevice> get onScanDevices => FlutterBluePlus.onScanResults.map((results) => results.map(scanResultConvertor));
  Stream<HeaderReceivedPacket> get onReceiveHeaderPacket;
  Stream<DataReceivedPacket> get onReceivedDataPacket;
}
