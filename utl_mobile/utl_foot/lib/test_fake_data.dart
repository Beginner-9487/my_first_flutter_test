import 'dart:async';
import 'dart:math';

import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/main.dart';
import 'package:utl_foot/resources/global_variables.dart';

void main() async {
  await mainInit();

  await Future.delayed(const Duration(seconds: 3));

  int i = 0;
  int bodyPart = BodyPart.LEFT_FOOT;
  Timer timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    // int bodyPart = Random.secure().nextBool() ? BodyPart.LEFT_FOOT : BodyPart.RIGHT_FOOT;
    bodyPart = (bodyPart == BodyPart.RIGHT_FOOT) ? BodyPart.LEFT_FOOT : BodyPart.RIGHT_FOOT;
    // bodyPart = BodyPart.LEFT_FOOT;
    await GlobalVariables.instance.footRepository.add((
      (DateTime.now().millisecondsSinceEpoch.toDouble() - GlobalVariables.instance.initTimeStamp.millisecondsSinceEpoch.toDouble()) / 1000.0,
      [
        bodyPart,
        ...List<int>.filled(241,Random.secure().nextInt(0xFF)),
      ]
    ));
    i++;
  });
}