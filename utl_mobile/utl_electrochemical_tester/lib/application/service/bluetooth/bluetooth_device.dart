import 'package:utl_electrochemical_tester/application/service/bluetooth/bluetooth_sent_packet.dart';

abstract class BluetoothDevice {
  String get id;
  set dataName(String dataName);
  String get dataName;
  String get deviceName;
  Future startCa(CaSentPacket packet);
  Future startCv(CvSentPacket packet);
  Future startDpv(DpvSentPacket packet);
}