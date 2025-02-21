import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_dto_handler.dart';
import 'package:utl_seat_cushion/init/initializer.dart';

import 'data/fake_bluetooth_dto_handler.dart';

class FakeInitializer extends ConcreteInitializer {
  @override
  BluetoothDtoHandler createBluetoothDtoHandler() {
    return fakeBluetoothDtoHandler;
  }
  final FakeBluetoothDtoHandler fakeBluetoothDtoHandler = FakeBluetoothDtoHandler();
  void dispose() {
    fakeBluetoothDtoHandler.dispose();
  }
}
