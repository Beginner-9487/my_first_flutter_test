import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_connection_task.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';

class BLEAutoReconnectService {
  BLERepository bleRepository;
  BLESelectedAutoReconnectService bleSelectedAutoReconnectService;
  late BLEConnectionTask bleConnectionTask;
  BLEAutoReconnectService._({
    required this.bleRepository,
    required this.bleSelectedAutoReconnectService,
  }) {
    bleConnectionTask = BLEConnectionTask(
        bleRepository: bleRepository,
        onConnectionDevice: (device, isConnected) {
          if(isConnected) {
            bleSelectedAutoReconnectService.addWantedAutoConnect(device);
          }
        }
    );
  }
  static BLEAutoReconnectService? _instance;
  static BLEAutoReconnectService getInstance({
    required BLERepository bleRepository,
    required BLESelectedAutoReconnectService bleSelectedAutoReconnectService,
  }) {
    _instance ??= BLEAutoReconnectService._(
      bleRepository: bleRepository,
      bleSelectedAutoReconnectService: bleSelectedAutoReconnectService,
    );
    return _instance!;
  }
}