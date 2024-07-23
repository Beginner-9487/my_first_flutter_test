import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/services/ble_selected_auto_reconnect_service.dart';

class BLESelectedAutoReconnectUseCase {
  BLESelectedAutoReconnectService bleSelectedAutoReconnectService;
  BLESelectedAutoReconnectUseCase({
    required this.bleSelectedAutoReconnectService,
  });
  addWantedAutoConnect(BLEDevice device) {
    bleSelectedAutoReconnectService.addWantedAutoConnect(device);
  }
  removeWantedAutoConnect(BLEDevice device) {
    bleSelectedAutoReconnectService.removeWantedAutoConnect(device);
  }
}