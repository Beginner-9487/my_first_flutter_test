import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_packet.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';
import 'package:utl_seat_cushion/resources/data_resources.dart';

import '../fake_initializer.dart';

class FakeDataGenerator {
  var headers = [
    0x11,
    0x12,
    0x13,
    0x21,
    0x22,
    0x23,
  ];
  var forcesLengths = [
    242,
    242,
    12,
    242,
    242,
    12,
  ];
  Timer? _generateFakeSeatCushionEntities;
  Timer? _generateFakeBluetoothPacket;
  int generateRandomForceInt() {
    return Random.secure().nextInt((SeatCushionEntity.forceMax - SeatCushionEntity.forceMin) + SeatCushionEntity.forceMin);
  }
  ByteData generateRandomForceByteData() {
    return ByteData(2)..setInt16(0, generateRandomForceInt(), Endian.little);
  }
  void startGenerateFakeSeatCushionEntities({
    required FakeInitializer fakeInitializer,
  }) {
    if(_generateFakeSeatCushionEntities != null) return;
    _generateFakeSeatCushionEntities = Timer.periodic(const Duration(milliseconds: 10,), (timer) async {
      fakeInitializer.fakeBluetoothDtoHandler.addSeatCushionEntity(
        entity: SeatCushionEntity(
          id: await DataResources.seatCushionRepository.generateEntityId(),
          deviceId: "",
          forces: List.generate(
            SeatCushionEntity.forceLength,
            (index) {
              return generateRandomForceInt();
            },
          ),
          type: SeatCushionType.values[Random.secure().nextInt(SeatCushionType.values.length)],
        ),
      );
    });
    return;
  }
  void startGenerateBluetoothPackets() {
    if(_generateFakeBluetoothPacket != null) return;
    _generateFakeBluetoothPacket = Timer.periodic(const Duration(milliseconds: 10,), (timer) async {
      int index = Random.secure().nextInt(headers.length);
      BluetoothResources.bluetoothDataModule.bluetoothDtoHandler.addPacket(
        packet: BluetoothPacket(
          data: Uint8List.fromList([
            headers[index],
            ...Iterable.generate(
              (forcesLengths[index] / 2).toInt(),
              (_) => generateRandomForceByteData().buffer.asUint8List(),
            ).expand((byteData) => byteData),
          ]),
          deviceId: "123",
        ),
      );
    });
    return;
  }
  void dispose() {
    _generateFakeSeatCushionEntities?.cancel();
    _generateFakeBluetoothPacket?.cancel();
  }
}