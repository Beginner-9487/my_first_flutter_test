import 'dart:math';

import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository_impl.dart';
import 'package:utl_mackay_irb/main.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';

void main() async {
  await mainInit();

  await Future.delayed(const Duration(seconds: 3));

  for(int index=0; index<1; index++) {
    MackayIRBEntityImpl currentEntity = (GlobalVariables.instance.mackayIRBRepository as MackayIRBRepositoryImpl).createNextEntity(
      name: "DPV-$index",
      raw: [
        MackayIRBType.DPV,
        0x02,
        0x58,
      ],
    ) as MackayIRBEntityImpl;
    for(int i=0; i<610; i++) {
      currentEntity.add([
        MackayIRBType.DPV,
        0x02,
        0x58,
        (i / 256).floor(),
        i % 256,
        ((i / 10).floor() / 256).floor(),
        ((i / 10).floor() % 256),
        i % 10,
        0x00,
        ...List.generate(6, (index) {
          return Random.secure().nextInt(5);
        }),
      ]);
    }

    currentEntity = (GlobalVariables.instance.mackayIRBRepository as MackayIRBRepositoryImpl).createNextEntity(
      name: "CORTISOL-$index",
      raw: [
        MackayIRBType.CORTISOL,
        0x02,
        0x58,
      ],
    ) as MackayIRBEntityImpl;
    for(int i=0; i<610; i++) {
      currentEntity.add([
        MackayIRBType.CORTISOL,
        0x02,
        0x58,
        (i / 256).floor(),
        i % 256,
        ((i / 10).floor() / 256).floor(),
        ((i / 10).floor() % 256),
        i % 10,
        0x00,
        ...List.generate(6, (index) {
          return Random.secure().nextInt(5);
        }),
      ]);
    }

    currentEntity = (GlobalVariables.instance.mackayIRBRepository as MackayIRBRepositoryImpl).createNextEntity(
      name: "LACTIC_ACID-$index",
      raw: [
        MackayIRBType.LACTIC_ACID,
        0x02,
        0x58,
      ],
    ) as MackayIRBEntityImpl;
    for(int i=0; i<610; i++) {
      // currentEntity.add([
      //   MackayIRBType.LACTIC_ACID,
      //   0x02,
      //   0x58,
      //   (i / 256).floor(),
      //   i % 256,
      //   ...List.generate(10, (index) {
      //     return Random.secure().nextInt(5);
      //   }),
      // ]);
      currentEntity.add([
        MackayIRBType.LACTIC_ACID,
        0x02,
        0x58,
        (i / 256).floor(),
        i % 256,
        ((i / 10).floor() / 256).floor(),
        ((i / 10).floor() % 256),
        i % 10,
        0x00,
        ...List.generate(6, (index) {
          return Random.secure().nextInt(5);
        }),
      ]);
    }
  }
}