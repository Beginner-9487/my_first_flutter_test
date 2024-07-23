import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_connection_task.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository_impl.dart';
import 'package:utl_mackay_irb/application/infrastructure/check_ble_packey.dart';
import 'package:utl_mackay_irb/resources/ble_uuid.dart';

class BLEMackayIRBService {

  late final BLEConnectionTask bleConnectionTask;
  late final BLEPacketListener blePacketListenerService;
  final List<_Dto> _nameBuffers = [];

  BLERepository bleRepository;
  final MackayIRBRepositoryImpl mackayIRBRepository;
  BLEMackayIRBService._({
    required this.bleRepository,
    required this.mackayIRBRepository,
  }) {
    bleConnectionTask = BLEConnectionTask(
        bleRepository: bleRepository,
        onConnectionDevice: _initNameBuffer
    );
    blePacketListenerService = BLEPacketListener(
      bleRepository: bleRepository,
      outputCharacteristicUUID: OUTPUT_UUID,
      onReceivedPacket: _addToRepository,
    );
  }
  static BLEMackayIRBService? _instance;
  static BLEMackayIRBService getInstance({
    required bleRepository,
    required mackayIRBRepository,
  }) {
    _instance ??= BLEMackayIRBService._(
      bleRepository: bleRepository,
      mackayIRBRepository: mackayIRBRepository,
    );
    return _instance!;
  }
  _initNameBuffer(BLEDevice device, bool isConnected) {
    if(_nameBuffers.where((element) => element.device == device).isEmpty) {
      _nameBuffers.add(_Dto(device: device));
    }
  }
  setDataNameBuffer(BLEDevice device, String name) {
    for(var item in _nameBuffers.where((element) => element.device == device)) {
      item.setName = name;
    }
  }
  _addToRepository(BLECharacteristic bleCharacteristic, BLEPacket packet) async {
    if(!CheckBLEPacket.isPacketCorrect(packet)) {return;}
    _Dto? dto = _nameBuffers
        .where((element) => element.device == bleCharacteristic.device)
        .firstOrNull;
    if(dto == null) {return;}
    if(dto!.currentEntity == null || dto!.currentEntity!.finished) {
      dto!.currentEntity = mackayIRBRepository.createNextEntity(
        name: dto!.nextName,
        raw: packet.raw,
      );
    }
    (dto!.currentEntity! as MackayIRBEntityImpl).add(packet.raw);
  }
}

class _Dto {
  BLEDevice device;
  late String _nameBuffer;
  MackayIRBEntity? currentEntity;
  _Dto({
    required this.device,
  }) {
    _nameBuffer = device.name;
  }
  set setName(String name) {
    _nameBuffer = name;
  }
  String get nextName {
    DateTime today = DateTime.now();
    return "$_nameBuffer-${today.year}-${today.month}-${today.day}-${today.hour}-${today.minute}-${today.second}";
  }
}