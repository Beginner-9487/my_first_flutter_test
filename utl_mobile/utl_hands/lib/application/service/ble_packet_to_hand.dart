import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_hands/application/domain/hand_repository_impl.dart';
import 'package:utl_hands/resources/global_variable.dart';

class BLEPacketToHand {
  BLEPacketToHand(
      this.repository,
      BLERepository bleRepository,
  ) {
    blePacketListener = BLEPacketListener(
        bleRepository: bleRepository,
        outputCharacteristicUUID: "6e400003-b5a3-f393-e0a9-e50e24dcca9e",
        onReceivedPacket: addToRepository,
    );
  }
  HandRepositoryImpl repository;
  late BLEPacketListener blePacketListener;
  @override
  addToRepository(BLECharacteristic bleCharacteristic, BLEPacket packet) {
    bool isRight = packet.raw[0] == 0x0B;
    double time = (DateTime.now().microsecondsSinceEpoch - GlobalVariable.initTime.microsecondsSinceEpoch) / 1000000.0;
    // double x0 = BytesConverter.byteArrayToFloat([0x00, 0x00, packet.raw[1], packet.raw[2]]);
    // double y0 = BytesConverter.byteArrayToFloat([0x00, 0x00, packet.raw[3], packet.raw[4]]);
    // double z0 = BytesConverter.byteArrayToFloat([0x00, 0x00, packet.raw[5], packet.raw[6]]);
    // double x1 = BytesConverter.byteArrayToFloat([0x00, 0x00, packet.raw[7], packet.raw[8]]);
    // double y1 = BytesConverter.byteArrayToFloat([0x00, 0x00, packet.raw[9], packet.raw[10]]);
    // double z1 = BytesConverter.byteArrayToFloat([0x00, 0x00, packet.raw[11], packet.raw[12]]);
    double x0 = BytesConverter.byteArrayToUnsignedInt([packet.raw[1], packet.raw[2]]).toDouble();
    double y0 = BytesConverter.byteArrayToUnsignedInt([packet.raw[3], packet.raw[4]]).toDouble();
    double z0 = BytesConverter.byteArrayToUnsignedInt([packet.raw[5], packet.raw[6]]).toDouble();
    double x1 = BytesConverter.byteArrayToUnsignedInt([packet.raw[7], packet.raw[8]]).toDouble();
    double y1 = BytesConverter.byteArrayToUnsignedInt([packet.raw[9], packet.raw[10]]).toDouble();
    double z1 = BytesConverter.byteArrayToUnsignedInt([packet.raw[11], packet.raw[12]]).toDouble();
    repository.add(isRight, time, x0, y0, z0, x1, y1, z1);
  }
}