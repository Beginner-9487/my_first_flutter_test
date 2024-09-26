import 'package:flutter_ble/application/domain/ble_repository.dart';

abstract class BLEMackayIRBDataSetter {
  setName(BLEDevice device, String name);
  String getName(BLEDevice device);
}