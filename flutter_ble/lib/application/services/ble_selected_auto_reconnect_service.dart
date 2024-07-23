import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_connection_task.dart';

class BLESelectedAutoReconnectService {
  BLERepository bleRepository;
  late BLEConnectionTask bleConnectionTask;
  BLESelectedAutoReconnectService._({
    required this.bleRepository,
  }) {
    bleConnectionTask = BLEConnectionTask(
        bleRepository: bleRepository,
        onConnectionDevice: (device, isConnected) {
          if(!isConnected) {
            if(_devices.where((element) => element == device).isNotEmpty) {
              device.connect();
            }
          }
        }
    );
  }
  static BLESelectedAutoReconnectService? _instance;
  static BLESelectedAutoReconnectService getInstance(BLERepository bleRepository) {
    _instance ??= BLESelectedAutoReconnectService._(
        bleRepository: bleRepository,
    );
    return _instance!;
  }

  final List<BLEDevice> _devices = [];
  addWantedAutoConnect(BLEDevice device) {
    if(_devices.where((element) => element == device).isEmpty) {
      _devices.add(device);
    }
  }
  removeWantedAutoConnect(BLEDevice device) {
    if(_devices.isEmpty) {return;}
    _devices.remove(device);
  }
}