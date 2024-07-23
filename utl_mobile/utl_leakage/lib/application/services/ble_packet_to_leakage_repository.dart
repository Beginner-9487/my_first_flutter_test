import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_leakage/application/domain/leakage_repository_impl.dart';
import 'package:utl_leakage/resources/ble_uuid.dart';
import 'package:utl_leakage/resources/global_variables.dart';

class BLEPacketToLeakageRepository {
  BLERepository bleRepository;
  LeakageRepositoryImpl leakageRepositoryImpl;
  late BLEPacketListener blePacketListener;
  BLEPacketToLeakageRepository(this.bleRepository, this.leakageRepositoryImpl) {
    blePacketListener = BLEPacketListener(
        bleRepository: bleRepository,
        outputCharacteristicUUID: OUTPUT_UUID,
        onReceivedPacket: onReceivedPacket
    );
  }
  onReceivedPacket(BLECharacteristic bleCharacteristic, BLEPacket bleReceivedPacket) {
    bleCharacteristic.onReadNotifiedData((packet) {
      leakageRepositoryImpl.add(
        DateTime.now().difference(GlobalVariables.instance.initTimeStamp).inMicroseconds / 1000000.0,
        packet.raw,
      );
    });
  }
}