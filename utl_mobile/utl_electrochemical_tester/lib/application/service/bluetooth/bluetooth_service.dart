import 'dart:async';

import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_device.dart';
import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_received_packet.dart';

abstract class BluetoothDevicesService<Device extends BluetoothDevice> {
  Iterable<Device> get devices;
  Stream<BluetoothDevice> get onScanDevices;
  Stream<HeaderReceivedPacket> get onReceiveHeaderPacket;
  Stream<DataReceivedPacket> get onReceivedDataPacket;
}
