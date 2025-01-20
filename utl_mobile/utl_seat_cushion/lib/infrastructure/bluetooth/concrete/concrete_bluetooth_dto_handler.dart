import 'dart:async';
import 'dart:typed_data';

import 'package:async_locks/async_locks.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_packet.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

enum BluetoothPacketDtoForcesStage {
  first,
  second,
  third,
}

class BluetoothPacketBuffer {
  final SeatCushionType seatCushionType;
  final String deviceId;
  final List<int> partForces;
  final BluetoothPacketDtoForcesStage forcesStage;
  static BluetoothPacketBuffer? create({
    required BluetoothPacket packet,
  }) {
    try{
      var packetLength = _extractPacketLength(bytes: packet.data);
      if(packetLength == null) return null;
      if(packetLength != packet.data.length) return null;
      var seatCushionType = _extractSeatCushionType(bytes: packet.data);
      if(seatCushionType == null) return null;
      var partForces = _extractPartForces(bytes: packet.data, offset: 1);
      if(partForces == null) return null;
      var forcesStage = _extractForcesStage(bytes: packet.data);
      if(forcesStage == null) return null;
      return BluetoothPacketBuffer._(
        seatCushionType: seatCushionType,
        deviceId: packet.deviceId,
        partForces: partForces,
        forcesStage: forcesStage,
      );
    } catch(e) {
      return null;
    }
  }
  BluetoothPacketBuffer._({
    required this.seatCushionType,
    required this.deviceId,
    required this.partForces,
    required this.forcesStage,
  });
  static int? _extractPacketLength({
    required Uint8List bytes,
  }) {
    if(bytes.first & 0x0F == 0x01) return 243;
    if(bytes.first & 0x0F == 0x02) return 243;
    if(bytes.first & 0x0F == 0x03) return 13;
    return null;
  }
  static SeatCushionType? _extractSeatCushionType({
    required Uint8List bytes,
  }) {
    if(bytes.first & 0xF0 == 0x10) return SeatCushionType.upper;
    if(bytes.first & 0xF0 == 0x20) return SeatCushionType.lower;
    return null;
  }
  static BluetoothPacketDtoForcesStage? _extractForcesStage({
    required Uint8List bytes,
  }) {
    if(bytes.first & 0x0F == 0x01) return BluetoothPacketDtoForcesStage.first;
    if(bytes.first & 0x0F == 0x02) return BluetoothPacketDtoForcesStage.second;
    if(bytes.first & 0x0F == 0x03) return BluetoothPacketDtoForcesStage.third;
    return null;
  }
  static List<int>? _extractPartForces({
    required Uint8List bytes,
    required int offset,
  }) {
    if(bytes.length <= offset) return null;
    final byteData = ByteData.sublistView(bytes);
    return [
      for (var i = offset; i < byteData.lengthInBytes; i += 2)
        byteData.getUint16(i, Endian.little)
    ];
  }
  @override
  String toString() {
    return "BluetoothPacketBuffer: "
        "\n\tseatCushionType: ${seatCushionType.name}"
        "\n\tdeviceId: $deviceId"
        "\n\tforcesStage: ${forcesStage.name}"
        "\n\tpartForces: $partForces"
    ;
  }
}

class ConcreteBluetoothDtoHandler extends BluetoothDtoHandler {
  Lock packetsLock = Lock();
  final SeatCushionRepository seatCushionRepository;
  ConcreteBluetoothDtoHandler({
    required this.seatCushionRepository,
  });
  @override
  void addPacket({
    required BluetoothPacket packet,
  }) async {
    try {
      await packetsLock.acquire();
      if(!_seatCushionDeviceIdWhitelist.contains(packet.deviceId)) _seatCushionDeviceIdWhitelist.add(packet.deviceId);
      var buffer = BluetoothPacketBuffer.create(packet: packet);
      if(buffer != null) {
        _buffers.add(buffer);
        await _handleSeatCushionDataStream();
        return;
      }
      return;
    } catch(e) {
      return;
    } finally {
      packetsLock.release();
    }
  }
  @override
  Stream<SeatCushionEntity> get seatCushionEntityStream => _seatCushionDataStreamController.stream;
  final StreamController<SeatCushionEntity> _seatCushionDataStreamController = StreamController.broadcast();
  final List<String> _seatCushionDeviceIdWhitelist = [];
  final List<BluetoothPacketBuffer> _buffers = [];
  _handleSeatCushionDataStream() async {
    for(var id in _seatCushionDeviceIdWhitelist) {
      var targetIdDevices = _buffers.where((b) => b.deviceId == id);
      for(var type in SeatCushionType.values) {
        var targetIdTypeForcesStageDevices = BluetoothPacketDtoForcesStage
          .values
          .map((stage) => targetIdDevices.where((buffer) => buffer.seatCushionType == type && buffer.forcesStage == stage));
        bool flag = true;
        for(var l in targetIdTypeForcesStageDevices) {
          if(l.isEmpty) {
            flag = false;
            break;
          }
        }
        if(!flag) continue;
        var forces = targetIdTypeForcesStageDevices
            .map((l) => l.first.partForces)
            .fold(<int>[], (previousValue, element) => previousValue..addAll(element));
        _seatCushionDataStreamController.add(
          SeatCushionEntity(
            id: await seatCushionRepository.generateEntityId(),
            deviceId: id,
            forces: forces,
            type: type,
          ),
        );
        _buffers.removeWhere(targetIdDevices.contains);
      }
    }
  }
  void dispose() {
    packetsLock.cancelAll();
    _seatCushionDataStreamController.close();
  }
}
