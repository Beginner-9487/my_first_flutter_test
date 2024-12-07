import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_characteristic_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_device_impl_fbp.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';

class BT_Service_Impl_FBP implements BT_Service {
  final BluetoothService _service;
  BT_Service_Impl_FBP(this.provider, this.device, this._service);

  @override
  BT_Provider_Impl_FBP provider;
  @override
  BT_Device_Impl_FBP device;

  @override
  String get uuid => _service.uuid.str128;

  @override
  Iterable<BT_Characteristic_Impl_FBP> get characteristics => _service
      .characteristics
      .map((item) => BT_Characteristic_Impl_FBP(
        provider,
        device,
        this,
        item,
      ));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BT_Service_Impl_FBP && other.uuid == uuid);

  @override
  int get hashCode => uuid.hashCode;
}