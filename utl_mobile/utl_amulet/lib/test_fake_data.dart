import 'dart:math';

import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp_true_with_fake.dart';
import 'package:utl_amulet/application/domain/amulet_repository_impl.dart';
import 'package:utl_amulet/main.dart';
import 'package:utl_amulet/resources/global_variables.dart';

void main() async {
  await mainInit();

  await Future.delayed(const Duration(seconds: 1));
  BLERepositoryImplFBPTrueWithFake bleRepositoryImplFBPTrueWithFake =
  BLERepositoryImplFBPTrueWithFake.getInstance((GlobalVariables.instance.bleRepository as BLERepositoryImplFBP));

  for(int i=0; i<4000; i++) {
    // List<int> data = List.filled(
    //   AmuletRepositoryImpl.NORMAL_PACKET_LENGTH,
    //   Random.secure().nextInt(0xFF),
    // );
    List<int> data = [];
    for(int i=0; i<AmuletRepositoryImpl.NORMAL_PACKET_LENGTH; i++) {
      data.add(Random.secure().nextInt(0x80));
    }
    (GlobalVariables.instance.amuletRepository as AmuletRepositoryImpl).add(
        time: DateTime.now().difference(GlobalVariables.instance.initTimeStamp).inMicroseconds / 1000000.0,
        device: GlobalVariables.instance.bleRepository.allDevices.first,
        raw: BLEPacketImplFBP
            .createByRaw(data)
            .raw,
    );
    await Future.delayed(const Duration(milliseconds: 20));
  }
}