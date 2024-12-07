import 'package:flutter_bt/bt.dart';

class BT_Service_Impl_Fake implements BT_Service {
  BT_Service_Impl_Fake(
      this.characteristics,
      this.device,
      this.provider,
      this.uuid,
      );

  @override
  Iterable<BT_Characteristic> characteristics;

  @override
  BT_Device device;

  @override
  BT_Provider provider;

  @override
  String uuid;

}