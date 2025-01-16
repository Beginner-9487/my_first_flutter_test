import 'package:utl_seat_cushion/domain/data/seat_cushion_data.dart';
import 'package:utl_seat_cushion/infrastructure/bluetooth/bluetooth_data_module.dart';

class SeatCushionBluetoothDevicesProvider implements SeatCushionDevicesProvider {
  final BluetoothDataModule bluetoothDataModule;
  SeatCushionBluetoothDevicesProvider({
    required this.bluetoothDataModule,
  });
  @override
  Future<bool> sendCommand({required String command}) async {
    bluetoothDataModule.sendHexString(command);
    return true;
  }
}
