import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_r/r.dart';
import 'package:flutter_util/screen/screen_size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/use_case/hand_to_line_chart.dart';
import 'package:utl_hands/application/use_case/save_file_use_case.dart';
import 'package:utl_hands/application/use_case/save_file_use_case_row.dart';
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
  HandRepository get handRepository => GlobalVariables.handRepository;

  late SaveFileUseCase saveFileUseCaseRow;

  static const int _LINE_CHART_UPDATE_RATE_MILLISECONDS = 50;
  bool leftLineChartFlag = false;
  bool rightLineChartFlag = false;
  late Timer leftLineChartTimer;
  late Timer rightLineChartTimer;
  
  late Widget _bleScanningView;
  late LineChartViewInfo _leftHandLineChart;
  late LineChartViewInfo _rightHandLineChart;
  late StreamSubscription<(bool, HandRow)> _onAdd;
  late UpdateBloc updateBlocData;

  late BLERepositoryBloc bleRepositoryBloc;
  late UpdateBloc updateBlocLeft;
  late LineChartListenerBloc lineChartListenerBlocLeft;
  late UpdateBloc updateBlocRight;
  late LineChartListenerBloc lineChartListenerBlocRight;

  late UpdateBloc updateBlocSaveFile;
  late Widget toolBar;

  final List<TextEditingController> _thresholdAlertTextFieldControllersLeft = List.generate(6, (index) => TextEditingController());
  final List<TextEditingController> _thresholdAlertTextFieldControllersRight = List.generate(6, (index) => TextEditingController());
  final List<String> _thresholdKeys = [
    "X0",
    "Y0",
    "Z0",
    "X1",
    "Y1",
    "Z1",
  ];
  List<String> get _thresholdSharedPreferenceKeys => [
    ..._thresholdKeys.map((e) => "L$e"),
    ..._thresholdKeys.map((e) => "R$e"),
  ];
  Iterable<Iterable<double>> get _thresholdLeftValues => List.generate(
    6,
    (index) {
      switch (index) {
        case 0:
          return handRepository.leftHandRows.map((e) => e.x0);
        case 1:
          return handRepository.leftHandRows.map((e) => e.y0);
        case 2:
          return handRepository.leftHandRows.map((e) => e.z0);
        case 3:
          return handRepository.leftHandRows.map((e) => e.x1);
        case 4:
          return handRepository.leftHandRows.map((e) => e.y1);
        case 5:
          return handRepository.leftHandRows.map((e) => e.z1);
        default:
          throw Exception();
      }
    },
  );
  Iterable<Iterable<double>> get _thresholdRightValues => List.generate(
    6,
    (index) {
      switch (index) {
        case 0:
          return handRepository.rightHandRows.map((e) => e.x0);
        case 1:
          return handRepository.rightHandRows.map((e) => e.y0);
        case 2:
          return handRepository.rightHandRows.map((e) => e.z0);
        case 3:
          return handRepository.rightHandRows.map((e) => e.x1);
        case 4:
          return handRepository.rightHandRows.map((e) => e.y1);
        case 5:
          return handRepository.rightHandRows.map((e) => e.z1);
        default:
          throw Exception();
      }
    },
  );
  Iterable<Iterable<double>> get _thresholdAllValues => _thresholdLeftValues.followedBy(_thresholdRightValues);

  final List<double?> _thresholdsLeft = List.generate(6, (index) => null);
  final List<double?> _thresholdsRight = List.generate(6, (index) => null);
  late final Widget _thresholdAlertTextFields;
  bool isAlarming = false;

  @override
  void initState() {
    updateBlocData = UpdateBloc();
    updateBlocSaveFile = UpdateBloc();

    _thresholdAlertTextFields = Scaffold(
      body: ListView(
        children: [
          ...List.generate(
            6,
            (index) => ListTile(
              leading: Text("L${_thresholdKeys[index]}"),
              title: TextField(
                controller: _thresholdAlertTextFieldControllersLeft[index],
                onChanged: (String value) {
                  try {
                    _thresholdsLeft[index] = double.parse(value);
                    GlobalVariables.sharedPreferences.setDouble(
                      _thresholdKeys[index],
                      _thresholdsLeft[index]!,
                    );
                  } catch (e) {
                    _thresholdsLeft[index] = null;
                  }
                },
              ),
              trailing: MultiBlocProvider(
                providers: [
                  BlocProvider<UpdateBloc>(
                      create: (BuildContext context) => updateBlocData
                  ),
                ],
                child: BlocBuilder<UpdateBloc, UpdateState>(
                  bloc: updateBlocData,
                  builder: (context, state) {
                    double maxValue = -100000;
                    double minValue = 100000;
                    if(_thresholdLeftValues.skip(index).first.isNotEmpty) {
                      maxValue = max(maxValue, _thresholdLeftValues.skip(index).first.last);
                    }
                    if(_thresholdLeftValues.skip(index).first.isNotEmpty) {
                      minValue = min(minValue, _thresholdLeftValues.skip(index).first.last);
                    }
                    return Text("$maxValue; $minValue");
                  },
                ),
              ),
            ),
          ),
          ...List.generate(
            6,
            (index) => ListTile(
              leading: Text("R${_thresholdKeys[index]}"),
              title: TextField(
                controller: _thresholdAlertTextFieldControllersRight[index],
                onChanged: (String value) {
                  try {
                    _thresholdsRight[index] = double.parse(value);
                    GlobalVariables.sharedPreferences.setDouble(
                        _thresholdKeys[index],
                        _thresholdsRight[index]!);
                  } catch (e) {
                    _thresholdsRight[index] = null;
                  }
                },
              ),
              trailing: MultiBlocProvider(
                providers: [
                  BlocProvider<UpdateBloc>(
                      create: (BuildContext context) => updateBlocData
                  ),
                ],
                child: BlocBuilder<UpdateBloc, UpdateState>(
                  bloc: updateBlocData,
                  builder: (context, state) {
                    double maxValue = -100000;
                    double minValue = 100000;
                    if(_thresholdRightValues.skip(index).first.isNotEmpty) {
                      maxValue = max(maxValue, _thresholdRightValues.skip(index).first.last);
                    }
                    if(_thresholdRightValues.skip(index).first.isNotEmpty) {
                      minValue = min(minValue, _thresholdRightValues.skip(index).first.last);
                    }
                    return Text("$maxValue; $minValue");
                  },
                ),
              ),
            ),
          ),
        ]
      ),
    );

    for(var controller in _thresholdAlertTextFieldControllersLeft.indexed) {
      double? value = GlobalVariables.sharedPreferences.getDouble(_thresholdSharedPreferenceKeys[controller.$1]);
      controller.$2.text = (value != null) ? value.toString() : "";
    }
    for(var controller in _thresholdAlertTextFieldControllersRight.indexed) {
      double? value = GlobalVariables.sharedPreferences.getDouble(_thresholdSharedPreferenceKeys[controller.$1 + 6]);
      controller.$2.text = (value != null) ? value.toString() : "";
    }

    bleRepositoryBloc = BLERepositoryBloc(GlobalVariables.bleRepository);
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

    _onAdd = GlobalVariables.handRepository.onAdd((isRight, row) {
      if(isRight) {
        rightLineChartFlag = true;
      } else {
        leftLineChartFlag = true;
      }
      if(
        (_thresholdsLeft[0] != null && row.x0 > _thresholdsLeft[0]!) ||
        (_thresholdsLeft[1] != null && row.y0 > _thresholdsLeft[1]!) ||
        (_thresholdsLeft[2] != null && row.z0 > _thresholdsLeft[2]!) ||
        (_thresholdsLeft[3] != null && row.x1 > _thresholdsLeft[3]!) ||
        (_thresholdsLeft[4] != null && row.y1 > _thresholdsLeft[4]!) ||
        (_thresholdsLeft[5] != null && row.z1 > _thresholdsLeft[5]!) ||
        (_thresholdsRight[0] != null && row.x0 > _thresholdsRight[0]!) ||
        (_thresholdsRight[1] != null && row.y0 > _thresholdsRight[1]!) ||
        (_thresholdsRight[2] != null && row.z0 > _thresholdsRight[2]!) ||
        (_thresholdsRight[3] != null && row.x1 > _thresholdsRight[3]!) ||
        (_thresholdsRight[4] != null && row.y1 > _thresholdsRight[4]!) ||
        (_thresholdsRight[5] != null && row.z1 > _thresholdsRight[5]!)
      ) {
        if(!isAlarming) {
          GlobalVariables.flutterRingTonePlayer.playAlarm();
          isAlarming = true;
        }
      } else {
        if(isAlarming) {
          GlobalVariables.flutterRingTonePlayer.stop();
          isAlarming = false;
        }
      }
      updateBlocData.add(const UpdateEvent());
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

    toolBar = MultiBlocProvider(
      providers: [
        BlocProvider<UpdateBloc>(
            create: (BuildContext context) => updateBlocSaveFile
        ),
      ],
      child: BlocBuilder<UpdateBloc, UpdateState>(
        bloc: updateBlocSaveFile,
        builder: (context, state) {
          return IconButton(
            color: (saveFileUseCaseRow.isSavingFile) ? Colors.blue : Colors.grey,
            onPressed: () async {
              if(saveFileUseCaseRow.isSavingFile) {
                await saveFileUseCaseRow.stopSavingFile();
              } else {
                await saveFileUseCaseRow.startSavingFile();
              }
              updateBlocSaveFile.add(const UpdateEvent());
            },
            icon: (saveFileUseCaseRow.isSavingFile) ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
          );
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    R.set(context);
    saveFileUseCaseRow = SaveFileUseCaseRow();
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
              toolBar,
              Expanded(child: _bleScanningView),
            ],
          ),
        )
      ],
    );
  }
}