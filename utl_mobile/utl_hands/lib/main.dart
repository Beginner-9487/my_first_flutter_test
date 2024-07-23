import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:utl_hands/application/domain/hand_repository_impl.dart';
import 'package:utl_hands/application/service/ble_packet_to_hand.dart';
import 'package:utl_hands/presentation/home_screen.dart';
import 'package:utl_hands/resources/global_variable.dart';

void main() {
  mainInit();
}

mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  DateTime initTime = DateTime.now();
  BLERepository bleRepository = BLERepositoryImplFBP.getInstance();
  HandRepositoryImpl handRepository = HandRepositoryImpl.getInstance();
  BLEPacketToHand blePacketToHand = BLEPacketToHand(handRepository, bleRepository);
  GlobalVariable.init(initTime, bleRepository, blePacketToHand, handRepository);
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}