import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:utl_amulet/adapter/amulet_device/amulet_devices_manager.dart';
import 'package:utl_amulet/adapter/amulet_device/dto/amulet_device_data_dto.dart';
import 'package:utl_amulet/infrastructure/source/bluetooth/bluetooth_devices_handler.dart';

class ConcreteAmuletDevicesManager implements AmuletDevicesManager {
  final BluetoothDevicesHandler bluetoothDevicesHandler;
  final StreamController<void> _controller = StreamController.broadcast();
  late final StreamSubscription _subscription;
  final List<AmuletDeviceDataDto> _buffer = [];
  final _lock = Lock();
  static const int bufferMaxLength = 100;
  void dispose() {
    _subscription.cancel();
  }
  ConcreteAmuletDevicesManager({
    required this.bluetoothDevicesHandler,
  }) {
    final dataStream = bluetoothDevicesHandler
      .onReceivePacket
      .map((packet) => packet.mapToData())
      .where((dto) => dto != null)
      .map((dto) => dto!);
    _subscription = dataStream.listen(
      (dto) {
        _lock.synchronized(() {
          _buffer.add(dto);
          while(_buffer.length > bufferMaxLength) {
            _buffer.removeAt(0);
          }
          _controller.add(null);
        });
      },
      onDone: () {
        _lock.synchronized(() {
          _controller.close();
        });
      }
    );
  }
  @override
  Stream<AmuletDeviceDataDto> get dataStream => _controller.stream
      .map((_) => _buffer.lastOrNull)
      .where((buffer) => buffer != null)
      .map((buffer) => buffer!);
  @override
  Stream<Iterable<AmuletDeviceDataDto>> get dtoBufferSyncStream => _controller.stream.map((_) => dtoBuffer);
  @override
  void clearBuffer() {
    _lock.synchronized(() {
      _buffer.clear();
      _controller.add(null);
    });
  }
  @override
  Iterable<AmuletDeviceDataDto> get dtoBuffer => _buffer;
  @override
  Stream<void> get clearStream => _controller.stream
      .where((event) => dtoBuffer.isEmpty);
}
