import 'dart:async';

import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_device.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_handler.dart';

class SeatCushionBluetoothDevicesProvider implements SeatCushionDevicesProvider {
  final BluetoothHandler bluetoothHandler;
  SeatCushionBluetoothDevicesProvider({
    required this.bluetoothHandler,
  });
  @override
  Future<bool> sendCommand({required String command}) async {
    bluetoothHandler.sendHexString(command);
    return true;
  }

  @override
  Stream<SeatCushionEntity> get receiveSeatCushionEntityStream => bluetoothHandler.bluetoothDtoHandler.seatCushionEntityStream;
}
