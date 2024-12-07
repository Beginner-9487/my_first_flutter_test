import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bt/bt.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_context_resource/context_resource_impl.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/domain/hand_repository_impl.dart';
import 'package:utl_hands/application/service/ble_packet_to_hand.dart';
import 'package:utl_hands/application/use_case/hand_to_line_chart.dart';
import 'package:utl_hands/application/use_case/save_file_use_case.dart';
import 'package:utl_hands/application/use_case/save_file_use_case_row.dart';
import 'package:utl_hands/presentation/bluetooth_scanner_view.dart';
import 'package:utl_hands/presentation/hand_line_chart_set.dart';
import 'package:utl_hands/presentation/threshold_controller_view.dart';
import 'package:utl_hands/presentation/tool_bar.dart';
import 'package:utl_mobile/utl_bt_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.handRepository,
    required this.sharedPreferences,
    required this.flutterRingTonePlayer,
    required this.bt_provider,
    required this.contextResourceProvider,
    required this.utl_bt_controller,
    required this.saveFileUseCaseRow,
  });
  final BT_Provider bt_provider;
  final HandRepository handRepository;
  final SharedPreferences sharedPreferences;
  final FlutterRingtonePlayer flutterRingTonePlayer;
  final ContextResourceProviderImpl contextResourceProvider;
  final UTL_BT_Controller utl_bt_controller;
  final SaveFileUseCase saveFileUseCaseRow;

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BT_Provider get bt_provider => widget.bt_provider;
  HandRepository get handRepository => widget.handRepository;
  SharedPreferences get sharedPreferences => widget.sharedPreferences;
  ContextResourceProvider get contextResourceProvider => widget.contextResourceProvider;
  FlutterRingtonePlayer get flutterRingTonePlayer => widget.flutterRingTonePlayer;
  UTL_BT_Controller get utl_bt_controller => widget.utl_bt_controller;
  SaveFileUseCase get saveFileUseCaseRow => widget.saveFileUseCaseRow;

  late ContextResource contextResource;

  late Toolbar toolBar;

  late HandLineChartSet handLineChartSet;
  late BluetoothScannerView bluetoothScannerView;
  late Threshold_Controller_View threshold_controller_view;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contextResource = contextResourceProvider.get(context);
    bluetoothScannerView = BluetoothScannerView(bt_provider, contextResource, utl_bt_controller);
    handLineChartSet = HandLineChartSet(handRepository: handRepository);
    bluetoothScannerView = BluetoothScannerView(bt_provider, contextResource, utl_bt_controller);
    threshold_controller_view = Threshold_Controller_View(
        handRepository: handRepository,
        sharedPreferences: sharedPreferences,
        flutterRingTonePlayer: flutterRingTonePlayer,
    );
    toolBar = Toolbar(saveFileUseCaseRow);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Row(
      children: [
        SizedBox(
          width: contextResource.screenWidth * 2 / 3,
          child: handLineChartSet,
        ),
        SizedBox(
          width: contextResource.screenWidth * 1 / 3,
          child: Column(
            children: [
              Expanded(child: threshold_controller_view),
              toolBar.build(),
              Expanded(child: bluetoothScannerView.build()),
            ],
          ),
        )
      ],
    );
  }
}