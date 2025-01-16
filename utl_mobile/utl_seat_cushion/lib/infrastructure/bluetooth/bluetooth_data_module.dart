import 'dart:async';

import 'package:utl_mobile/utl_bluetooth/fbp_utl_bluetooth_handler.dart';
import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_packet.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/resources/bluetooth_resources.dart';

class _Resources extends FbpUtlBluetoothSharedResources<SeatCushionDevice, BluetoothPacket> {
  _Resources({
    required super.sentUuid,
    required super.receivedUuid,
  }) : super(
    toPacket: (device, data) => BluetoothPacket(
        data: data,
        deviceId: device.bluetoothDevice.remoteId.str,
    ),
  );
}

class SeatCushionDevice extends UtlBluetoothDevice {
  SeatCushionDevice({
    required super.resource,
    required super.bluetoothDevice,
  });
}

class BluetoothDataModule extends FbpUtlBluetoothHandler<SeatCushionDevice, BluetoothPacket, _Resources>  {
  final BluetoothDtoHandler bluetoothDtoHandler;
  final SaveSeatCushionUseCase saveSeatCushionUseCase;
  BluetoothDataModule({
    required super.devices,
    required this.bluetoothDtoHandler,
    required this.saveSeatCushionUseCase,
  }) : super(
    resources: _Resources(
      sentUuid: BluetoothResources.sentUuids,
      receivedUuid: BluetoothResources.receivedUuids,
    ),
    bluetoothDeviceToDevice: (resource, bluetoothDevice) => SeatCushionDevice(
      resource: resource,
      bluetoothDevice: bluetoothDevice,
    ),
    resultToDevice: (resource, result) => SeatCushionDevice(
      resource: resource,
      bluetoothDevice: result.device,
    ),
  ) {
    _saveSeatCushionData = bluetoothDtoHandler.seatCushionEntityStream.listen((data) {
      saveSeatCushionUseCase.save(data);
    });
    _receivePacket = onReceivePacket.listen((packet) {
      bluetoothDtoHandler.addPacket(packet: packet);
    });
  }
  late final StreamSubscription<SeatCushionEntity> _saveSeatCushionData;
  late final StreamSubscription<BluetoothPacket> _receivePacket;
  @override
  void dispose() {
    _saveSeatCushionData.cancel();
    _receivePacket.cancel();
    super.dispose();
  }
}