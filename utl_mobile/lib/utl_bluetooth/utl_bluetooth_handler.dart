import 'dart:async';
import 'dart:typed_data';

abstract class UtlBluetoothPacket {
  String get name;
  String get id;
  Uint8List get data;
}

abstract class UtlBluetoothHandler<Device, Data> {
  UtlBluetoothHandler({
    required Data Function(UtlBluetoothPacket packet) dataEncoder,
    Iterable<String> inputUuid = const [],
    Iterable<String> outputUuid = const [],
  });
  Future sendBytes(Uint8List bytes);
  Future sendHexString(String hexString);
  StreamSubscription<Data> onReceiveData(void Function(Data data) onReceiveData);
}