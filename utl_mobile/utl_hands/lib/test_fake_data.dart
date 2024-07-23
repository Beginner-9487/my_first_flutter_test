import 'dart:async';
import 'dart:math';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fake.dart';
import 'package:utl_hands/application/domain/hand_repository_impl.dart';
import 'package:utl_hands/main.dart';
import 'package:utl_hands/resources/global_variable.dart';

void main() {
  test();
}

void test() async {
  await mainInit();

  await Future.delayed(const Duration(seconds: 3));
  GlobalVariable.bleRepository = BLERepositoryImplFake.getInstance();

  int i = 0;
  Timer timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    testBLEPacketToHand(i++);
  });
}

testAddHandRepository(int index) {
  // bool isRight = Random.secure().nextBool();
  bool isRight = true;
  double time = (DateTime.now().microsecondsSinceEpoch - GlobalVariable.initTime.microsecondsSinceEpoch) / 1000000.0;
  double x0 = Random.secure().nextDouble() * 10.0;
  double y0 = Random.secure().nextDouble() * 10.0;
  double z0 = Random.secure().nextDouble() * 10.0;
  double x1 = Random.secure().nextDouble() * 10.0;
  double y1 = Random.secure().nextDouble() * 10.0;
  double z1 = Random.secure().nextDouble() * 10.0;
  (GlobalVariable.handRepository as HandRepositoryImpl).add(isRight, time, x0, y0, z0, x1, y1, z1);
}

BLEDeviceImplFake deviceImplFake = BLEDeviceImplFake(
    GlobalVariable.bleRepository as BLERepositoryImplFake,
    "name",
    "address",
    "platformName",
    0,
    0,
    "manufacturerData"
);
BLEServiceImplFake serviceImplFake = BLEServiceImplFake(
  GlobalVariable.bleRepository as BLERepositoryImplFake,
  deviceImplFake,
);
testBLEPacketToHand(int index) {
  // bool isRight = Random.secure().nextBool();
  GlobalVariable.blePacketToHand
      .addToRepository(
      BLECharacteristicImplFake(
        GlobalVariable.bleRepository as BLERepositoryImplFake,
        // GlobalVariable.bleRepository.allDevices.first as BLEDeviceImplFake,
        // GlobalVariable.bleRepository.allDevices.first.services.first as BLEServiceImplFake,
        deviceImplFake,
        serviceImplFake,
      ),
      BLEPacketImplFake.createByRaw([
        Random.secure().nextBool() ? 0x0a : 0x0b,
        // ...List.generate(12, (index) {
        //   if(index % 2 == 0) {
        //     return 0x00;
        //   } else {
        //     return Random.secure().nextInt(0xFF);
        //   }
        // }),
        ...List.generate(12, (index) => Random.secure().nextInt(0xFF)),
      ]),
  );
}