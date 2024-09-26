import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp_true_with_fake.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository_impl.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_type_impl.dart';
import 'package:utl_mackay_irb/main.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';

void main() async {
  await mainInit();

  await Future.delayed(const Duration(seconds: 3));

  BLERepositoryImplFBPTrueWithFake bleRepositoryImplFBPTrueWithFake = BLERepositoryImplFBPTrueWithFake.getInstance(GlobalVariables.instance.bleRepository as BLERepositoryImplFBP);

  String name = "AAA";
  BLEDevice device = GlobalVariables.instance.bleRepository.allDevices.first;

  for(int index=0; index<1; index++) {

    double temperature = Random.secure().nextDouble() * 40;
    var bytes_temperature =
    (
        ByteData(4)
          ..setFloat32(
              0,
              temperature,
              Endian.little
          )
    )
        .buffer
        .asUint8List()
    ;

    (GlobalVariables.instance.mackayIRBRepository as MackayIRBRepositoryImpl).add_new_data(
      name: name,
      device: device,
      raw: [
        TemperatureMackayIRBType().id,
        ...bytes_temperature,
        ...List.generate(15, (index) {
          return Random.secure().nextInt(0x00);
        }),
      ],
    ) as MackayIRBEntityImpl;

    int data_length = 100;
    var bytes_data_length =
    (
        ByteData(2)
          ..setInt16(
              0,
              data_length,
              Endian.little
          )
    )
        .buffer
        .asUint8List()
    ;

    for(int i=0; i<data_length; i++) {

      var bytes_index =
      (
          ByteData(2)
            ..setInt16(
                0,
                i,
                Endian.little
            )
      )
          .buffer
          .asUint8List()
      ;

      double voltage = Random.secure().nextDouble() * 40;
      var bytes_voltage =
      (
          ByteData(4)
            ..setFloat32(
                0,
                voltage,
                Endian.little
            )
      )
          .buffer
          .asUint8List()
      ;

      double current = Random.secure().nextDouble() * 40;
      var bytes_current =
      (
          ByteData(4)
            ..setFloat32(
                0,
                current,
                Endian.little
            )
      )
          .buffer
          .asUint8List()
      ;

      (GlobalVariables.instance.mackayIRBRepository as MackayIRBRepositoryImpl).add_new_data(
        name: name,
        device: device,
        raw: [
          (index == 0) ? CortisolMackayIRBType().id : LactateMackayIRBType().id,
          ...bytes_index,
          ...bytes_data_length,
          ...bytes_voltage,
          ...bytes_current,
          ...List.generate(8, (index) {
            return Random.secure().nextInt(0x00);
          }),
        ],
      ) as MackayIRBEntityImpl;
    }
  }
}