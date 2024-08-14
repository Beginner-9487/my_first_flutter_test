import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_amulet/application/domain/amulet_repository_impl.dart';
import 'package:utl_amulet/resources/ble_uuid.dart';
import 'package:utl_amulet/resources/global_variables.dart';

class BLEAmuletService {

  late final BLEPacketListener blePacketListener;

  final BLERepository _bleRepository;
  final AmuletRepositoryImpl _amuletRepositoryImpl;

  BLEAmuletService._(this._bleRepository, this._amuletRepositoryImpl) {
    blePacketListener = BLEPacketListener(
      bleRepository: _bleRepository,
      outputCharacteristicUUID: OUTPUT_UUID,
      onReceivedPacket: _addToRepository,
    );
  }
  static BLEAmuletService? _instance;
  static BLEAmuletService getInstance({
    required bleRepository,
    required amuletRepository,
  }) {
    _instance ??= BLEAmuletService._(
      bleRepository,
      amuletRepository,
    );
    return _instance!;
  }

  _addToRepository(BLECharacteristic bleCharacteristic, BLEPacket packet) async {
    _amuletRepositoryImpl.add(
        time: DateTime.now().difference(GlobalVariables.instance.initTimeStamp).inMicroseconds / 1000000.0,
        device: bleCharacteristic.device,
        raw: packet.raw
    );
  }
}