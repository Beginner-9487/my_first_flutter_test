import 'package:flutter/material.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_bt/flutter_blue_plus/bt_provider_impl_fbp.dart';
import 'package:flutter_context_resource/context_resource_impl.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:flutter_system_path/system_path_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_hands/application/domain/hand_repository_impl.dart';
import 'package:utl_hands/application/service/ble_packet_to_hand.dart';
import 'package:utl_hands/application/use_case/save_file_use_case.dart';
import 'package:utl_hands/application/use_case/save_file_use_case_row.dart';
import 'package:utl_hands/presentation/home_screen.dart';
import 'package:utl_mobile/utl_bluetooth_handler.dart';
import 'package:utl_mobile/fbp_utl_bluetooth_handler.dart';

void main() {
  mainInit();
}

mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  DateTime initTime = DateTime.now();
  SystemPath systemPath = await SystemPathImpl.getInstance();
  BT_Provider bt_provider = BT_Provider_Impl_FBP.getInstance();
  HandRepositoryImpl handRepository = HandRepositoryImpl.getInstance();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  FlutterRingtonePlayer flutterRingTonePlayer = FlutterRingtonePlayer();
  ContextResourceProviderImpl contextResourceProvider = ContextResourceProviderImpl.getInstance();
  UTL_BT_Controller utl_bt_controller = UTL_BT_Controller_Impl(provider: bt_provider);
  BT_Packet_To_Hand btPacketToHand = BT_Packet_To_Hand(utl_bt_controller, initTime, handRepository);
  SaveFileUseCase saveFileUseCaseRow = SaveFileUseCaseRow.getInstance(systemPath, bt_provider, handRepository);
  runApp(AppRoot(
    handRepository: handRepository,
    sharedPreferences: sharedPreferences,
    flutterRingTonePlayer: flutterRingTonePlayer,
    btPacketToHand: btPacketToHand,
    initTime: initTime,
    bt_provider: bt_provider,
    contextResourceProvider: contextResourceProvider,
    utl_bt_controller: utl_bt_controller,
    saveFileUseCaseRow: saveFileUseCaseRow,
  ));
}

class AppRoot extends StatelessWidget {
  AppRoot({
    super.key,
    required this.handRepository,
    required this.sharedPreferences,
    required this.flutterRingTonePlayer,
    required this.btPacketToHand,
    required this.initTime,
    required this.bt_provider,
    required this.contextResourceProvider,
    required this.utl_bt_controller,
    required this.saveFileUseCaseRow,
  });
  DateTime initTime;
  BT_Provider bt_provider;
  HandRepositoryImpl handRepository;
  BT_Packet_To_Hand btPacketToHand;
  SharedPreferences sharedPreferences;
  FlutterRingtonePlayer flutterRingTonePlayer;
  ContextResourceProviderImpl contextResourceProvider;
  UTL_BT_Controller utl_bt_controller;
  SaveFileUseCase saveFileUseCaseRow;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        handRepository: handRepository,
        sharedPreferences: sharedPreferences,
        flutterRingTonePlayer: flutterRingTonePlayer,
        bt_provider: bt_provider,
        contextResourceProvider: contextResourceProvider,
        utl_bt_controller: utl_bt_controller,
        saveFileUseCaseRow: saveFileUseCaseRow,
      ),
    );
  }
}