import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';

class BLESelectedAutoReadRSSIService {
  BLERepository bleRepository;
  late Timer timer;
  BLESelectedAutoReadRSSIService._({
    required this.bleRepository,
    required int readRSSIMilliseconds,
  }) {
    timer = Timer.periodic(Duration(milliseconds: readRSSIMilliseconds), (timer) {
      for(var device in _devices) {
        device.readRssi();
      }
    });
  }
  static BLESelectedAutoReadRSSIService? _instance;
  static BLESelectedAutoReadRSSIService getInstance(BLERepository bleRepository, int readRSSIMilliseconds) {
    _instance ??= BLESelectedAutoReadRSSIService._(
      bleRepository: bleRepository,
      readRSSIMilliseconds: readRSSIMilliseconds,
    );
    return _instance!;
  }

  final List<BLEDevice> _devices = [];
  addWantedRead(BLEDevice device) {
    if(_devices.where((element) => element == device).isEmpty) {
      _devices.add(device);
    }
  }
  removeWantedRead(BLEDevice device) {
    if(_devices.isEmpty) {return;}
    _devices.remove(device);
  }
}