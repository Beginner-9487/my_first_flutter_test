import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/use_case/hand_to_line_chart.dart';
import 'package:utl_hands/resources/global_variable.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_bloc.dart';
import 'package:utl_mobile/presentation/bloc/ble/device/ble_device_event.dart';
import 'package:utl_mobile/presentation/bloc/ble/repository/ble_repository_bloc.dart';
import 'package:utl_mobile/presentation/bloc/line_chart/line_chart_listerner_bloc.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';
import 'package:utl_mobile/presentation/view/ble_scanning_view.dart';
import 'package:utl_mobile/presentation/view/line_chart_view.dart';
import 'package:utl_mobile/presentation/widgets/scanned_ble_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _LINE_CHART_UPDATE_RATE_MILLISECONDS = 50;
  bool leftLineChartFlag = false;
  bool rightLineChartFlag = false;
  late Timer leftLineChartTimer;
  late Timer rightLineChartTimer;
  
  late Widget _bleScanningView;
  late LineChartViewInfo _leftHandLineChart;
  late LineChartViewInfo _rightHandLineChart;
  late StreamSubscription<(bool, HandRow)> _onAdd;

  late BLERepositoryBloc bleRepositoryBloc;
  late UpdateBloc updateBlocLeft;
  late LineChartListenerBloc lineChartListenerBlocLeft;
  late UpdateBloc updateBlocRight;
  late LineChartListenerBloc lineChartListenerBlocRight;

  final List<TextEditingController> _thresholdAlertTextFieldControllers = List.generate(6, (index) => TextEditingController());
  final List<String> _thresholdKeys = [
    "X0",
    "Y0",
    "Z0",
    "X1",
    "Y1",
    "Z1",
  ];
  final List<double?> _thresholds = List.generate(6, (index) => null);
  late final Widget _thresholdAlertTextFields;
  bool isAlarming = false;

  @override
  void initState() {
    _thresholdAlertTextFields = Scaffold(
      body: ListView(
        children: List.generate(
          6,
          (index) => ListTile(
            leading: Text(_thresholdKeys[index]),
            title: TextField(
              controller: _thresholdAlertTextFieldControllers[index],
              onChanged: (String value) {
                try {
                  _thresholds[index] = double.parse(value);
                  GlobalVariable.sharedPreferences.setDouble(_thresholdKeys[index], _thresholds[index]!);
                } catch (e) {
                  _thresholds[index] = null;
                }
              },
            ),
          )
        )
      ),
    );

    for(var controller in _thresholdAlertTextFieldControllers.indexed) {
      double? value = GlobalVariable.sharedPreferences.getDouble(_thresholdKeys[controller.$1]);
      controller.$2.text = (value != null) ? value.toString() : "";
    }

    bleRepositoryBloc = BLERepositoryBloc(GlobalVariable.bleRepository);
    updateBlocLeft = UpdateBloc();
    lineChartListenerBlocLeft = LineChartListenerBloc();
    updateBlocRight = UpdateBloc();
    lineChartListenerBlocRight = LineChartListenerBloc();

    _bleScanningView = BLEScanningView(
      bleRepositoryBloc: bleRepositoryBloc,
      scannedBLETile: (BLEDevice device) {
        return ScannedBLETile(
          bleDeviceBloc: BLEDeviceBloc(device),
          colorConnected: Colors.blue,
          colorDisconnected: Colors.red,
          textConnected: "連線",
          textDisconnected: "斷線",
          onConnect: (BLEDeviceBloc bleDeviceBloc) {
            bleDeviceBloc.add(BLEDeviceConnect());
          },
          onDisconnect: (BLEDeviceBloc bleDeviceBloc) {
            bleDeviceBloc.add(BLEDeviceDisconnect());
          },
        );
      },
    );
    _leftHandLineChart = LineChartViewInfo(
      updateBloc: updateBlocLeft,
      lineChartListenerBloc: lineChartListenerBlocLeft,
      primaryYAxis: NumericAxis(minimum: 25000),
    );
    _rightHandLineChart = LineChartViewInfo(
      updateBloc: updateBlocRight,
      lineChartListenerBloc: lineChartListenerBlocRight,
      primaryYAxis: NumericAxis(minimum: 25000),
    );

    _onAdd = GlobalVariable.handRepository.onAdd((isRight, row) {
      if(isRight) {
        rightLineChartFlag = true;
      } else {
        leftLineChartFlag = true;
      }
      if(
        (_thresholds[0] != null && row.x0 > _thresholds[0]!) ||
        (_thresholds[1] != null && row.y0 > _thresholds[1]!) ||
        (_thresholds[2] != null && row.z0 > _thresholds[2]!) ||
        (_thresholds[3] != null && row.x1 > _thresholds[3]!) ||
        (_thresholds[4] != null && row.y1 > _thresholds[4]!) ||
        (_thresholds[5] != null && row.z1 > _thresholds[5]!)
      ) {
        if(!isAlarming) {
          GlobalVariable.flutterRingTonePlayer.playAlarm();
          isAlarming = true;
        }
      } else {
        if(isAlarming) {
          GlobalVariable.flutterRingTonePlayer.stop();
          isAlarming = false;
        }
      }
    });

    leftLineChartTimer = Timer.periodic(const Duration(milliseconds: _LINE_CHART_UPDATE_RATE_MILLISECONDS), (timer) {
      if(leftLineChartFlag && !lineChartListenerBlocLeft.onTouched && !lineChartListenerBlocRight.onTouched) {
        _leftHandLineChart
        .updateChart((
          [],
          HandToLineChart.left.toList(),
        ));
        leftLineChartFlag = false;
      }
    });

    rightLineChartTimer = Timer.periodic(const Duration(milliseconds: _LINE_CHART_UPDATE_RATE_MILLISECONDS), (timer) {
      if(rightLineChartFlag && !lineChartListenerBlocLeft.onTouched && !lineChartListenerBlocRight.onTouched) {
        _rightHandLineChart
        .updateChart((
          [],
          HandToLineChart.right.toList(),
        ));
        rightLineChartFlag = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     Expanded(child: _leftHandLineChart),
    //     Expanded(child: _rightHandLineChart),
    //     Expanded(child: _bleScanningView),
    //   ],
    // );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Row(
      children: [
        SizedBox(
          width: screenWidth(context) * 2 / 3,
          child: Column(
            children: [
              const Text(
                "Left Hand",
                style: TextStyle(fontSize: 14),
              ),
              Expanded(child: _leftHandLineChart),
              const Text(
                "Right Hand",
                style: TextStyle(fontSize: 14),
              ),
              Expanded(child: _rightHandLineChart),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth(context) * 1 / 3,
          child: Column(
            children: [
              Expanded(child: _thresholdAlertTextFields),
              Expanded(child: _bleScanningView),
            ],
          ),
        )
      ],
    );
  }
}