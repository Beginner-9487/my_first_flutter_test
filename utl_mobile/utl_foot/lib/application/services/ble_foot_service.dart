import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/infrastructure/check_ble_packet.dart';
import 'package:utl_foot/resources/ble_uuid.dart';
import 'package:utl_foot/resources/global_variables.dart';

class BLEFootService {

  late final BLEPacketListener _blePacketListener;

  final BLERepository _bleRepository;
  final FootRepository _footRepository;

  BLEFootService._(
      this._bleRepository,
      this._footRepository,
  ) {
    _blePacketListener = BLEPacketListener(
      bleRepository: _bleRepository,
      outputCharacteristicUUID: OUTPUT_UUID,
      onReceivedPacket: _addToRepository,
    );
  }
  static BLEFootService? _instance;
  static BLEFootService getInstance(
      BLERepository bleRepository,
      FootRepository footRepository,
  ) {
    _instance ??= BLEFootService._(bleRepository, footRepository);
    return _instance!;
  }

  _addToRepository(BLECharacteristic bleCharacteristic, BLEPacket packet) async {
    if(CheckBLEPacketFoot.isPacketCorrect(packet)) {
      _footRepository.add((
        DateTime.now().difference(GlobalVariables.instance.initTimeStamp).inMicroseconds / 1000000.0,
        packet.raw,
      ));
    }
  }
}