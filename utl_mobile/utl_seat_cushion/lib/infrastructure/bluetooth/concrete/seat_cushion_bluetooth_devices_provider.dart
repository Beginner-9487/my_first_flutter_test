import 'dart:async';

import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_device.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_data_module.dart';

class SeatCushionBluetoothDevicesProvider implements SeatCushionDevicesProvider {
  final BluetoothDataModule bluetoothDataModule;
  SeatCushionBluetoothDevicesProvider({
    required this.bluetoothDataModule,
  });
  @override
  Future<bool> sendCommand({required String command}) async {
    bluetoothDataModule.sendHexString(command);
    return true;
  }

  @override
  Stream<SeatCushionEntity> get receiveSeatCushionEntityStream => bluetoothDataModule.bluetoothDtoHandler.seatCushionEntityStream;
}
