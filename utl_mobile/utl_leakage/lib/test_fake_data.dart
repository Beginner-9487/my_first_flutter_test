import 'dart:async';
import 'dart:math';

import 'package:utl_leakage/application/domain/leakage_repository.dart';
import 'package:utl_leakage/application/domain/leakage_repository_impl.dart';
import 'package:utl_leakage/main.dart';
import 'package:utl_leakage/resources/global_variables.dart';

void main() async {
  await mainInit();

  await Future.delayed(const Duration(seconds: 3));

  // Timer timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
  //   (GlobalVariables.instance.leakageRepository as LeakageRepositoryImpl).add(
  //       (DateTime.now().microsecondsSinceEpoch.toDouble() - GlobalVariables.instance.initTimeStamp.microsecondsSinceEpoch.toDouble()) / 1000000.0,
  //       [
  //         // Random.secure().nextInt(LeakageRepository.EXTRA_LEAKAGE_WARNING_VOLTAGE.toInt() * 2),
  //         // Random.secure().nextInt(LeakageRepository.INTRA_LEAKAGE_WARNING_VOLTAGE.toInt() * 2),
  //         Random.secure().nextInt(10),
  //         Random.secure().nextInt(10),
  //       ]
  //   );
  // });

  int data = 0;
  const int step = 2;
  double cycle = LeakageRepository.EXTRA_LEAKAGE_WARNING_VOLTAGE * step * 4;
  double max = LeakageRepository.EXTRA_LEAKAGE_WARNING_VOLTAGE * step * 2;
  Timer timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    double currentSecond = (DateTime.now().microsecondsSinceEpoch.toDouble() - GlobalVariables.instance.initTimeStamp.microsecondsSinceEpoch.toDouble()) / 1000000.0;
    (GlobalVariables.instance.leakageRepository as LeakageRepositoryImpl).add(
        currentSecond,
        [
          // Random.secure().nextInt(LeakageRepository.EXTRA_LEAKAGE_WARNING_VOLTAGE.toInt() * 2),
          // Random.secure().nextInt(LeakageRepository.INTRA_LEAKAGE_WARNING_VOLTAGE.toInt() * 2),
          data,
          data,
        ]
    );
    data = (currentSecond % cycle < max)
        ? (currentSecond % cycle) ~/ step
        : (((2 * max) - currentSecond) % cycle) ~/ step ;
  });
}