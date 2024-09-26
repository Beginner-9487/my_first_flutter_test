import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository_impl.dart';
import 'package:utl_mackay_irb/application/infrastructure/check_ble_packey.dart';
import 'package:utl_mackay_irb/application/services/ble_mackay_irb_data_setter.dart';
import 'package:utl_mackay_irb/resources/ble_uuid.dart';

class BLEMackayIRBDataSetterImpl extends BLEMackayIRBDataSetter {

  late final BLEPacketListener blePacketListenerService;
  final List<_BLEMackayIRBDataSetterImplBuffer> _buffers = [];

  BLERepository bleRepository;
  final MackayIRBRepositoryImpl mackayIRBRepository = MackayIRBRepositoryImpl.getInstance();
  BLEMackayIRBDataSetterImpl._({
    required this.bleRepository,
  }) {
    blePacketListenerService = BLEPacketListener(
      bleRepository: bleRepository,
      outputCharacteristicUUID: OUTPUT_UUID,
      onReceivedPacket: _addToRepository,
    );
  }
  static BLEMackayIRBDataSetterImpl? _instance;
  static BLEMackayIRBDataSetterImpl getInstance({
    required bleRepository,
  }) {
    _instance ??= BLEMackayIRBDataSetterImpl._(
      bleRepository: bleRepository,
    );
    return _instance!;
  }
  @override
  setName(BLEDevice device, String name) {
    _BLEMackayIRBDataSetterImplBuffer? buffer = _buffers.where((element) => element.device == device).firstOrNull;
    if(buffer == null) {
      buffer = _BLEMackayIRBDataSetterImplBuffer(
        device: device,
        name: name,
      );
      _buffers.add(buffer);
    } else {
      buffer.name == name;
    }
  }
  _addToRepository(BLECharacteristic bleCharacteristic, BLEPacket packet) async {
    if(!CheckBLEPacket.isPacketCorrect(packet)) {return;}
    _BLEMackayIRBDataSetterImplBuffer? buffer = _buffers.where((element) => element.device == bleCharacteristic.device).firstOrNull;
    if(buffer == null) {return;}
    mackayIRBRepository.add_new_data(
      raw: packet.raw,
      name: buffer.name,
      device: buffer.device,
    );
  }

  @override
  String getName(BLEDevice device) {
    _BLEMackayIRBDataSetterImplBuffer? buffer = _buffers.where((element) => element.device == device).firstOrNull;
    return (buffer != null) ? buffer.name : "";
  }
}

class _BLEMackayIRBDataSetterImplBuffer {
  BLEDevice device;
  String name;
  _BLEMackayIRBDataSetterImplBuffer({
    required this.device,
    required this.name,
  });
}