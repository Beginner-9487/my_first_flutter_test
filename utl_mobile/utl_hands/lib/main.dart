import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/domain/ble_repository_impl_fbp.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  FlutterRingtonePlayer flutterRingTonePlayer = FlutterRingtonePlayer();
  GlobalVariable.init(initTime, bleRepository, blePacketToHand, handRepository, sharedPreferences, flutterRingTonePlayer);
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