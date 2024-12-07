import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc.dart';
import 'package:flutter_customize_bloc/update_bloc_impl.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';

class Threshold_Controller_View extends StatefulWidget {
  const Threshold_Controller_View({
    super.key,
    required this.handRepository,
    required this.sharedPreferences,
    required this.flutterRingTonePlayer,
  });
  final HandRepository handRepository;
  final SharedPreferences sharedPreferences;
  final FlutterRingtonePlayer flutterRingTonePlayer;

  @override
  State createState() => _Threshold_Controller_View_State();
}

class _Threshold_Controller_View_State extends State<Threshold_Controller_View> {
  HandRepository get handRepository => widget.handRepository;
  SharedPreferences get sharedPreferences => widget.sharedPreferences;
  FlutterRingtonePlayer get flutterRingTonePlayer => widget.flutterRingTonePlayer;

  bool leftLineChartFlag = false;
  bool rightLineChartFlag = false;

  late UpdateBloc updateBloc;
  late StreamSubscription<(bool, HandRow)> _onAdd;

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
    super.initState();

    updateBloc = UpdateBlocImpl();

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
                      sharedPreferences.setDouble(
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
                    BlocProvider(
                        create: (BuildContext context) => updateBloc
                    ),
                  ],
                  child: BlocBuilder(
                    bloc: updateBloc,
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
                      sharedPreferences.setDouble(
                          _thresholdKeys[index],
                          _thresholdsRight[index]!);
                    } catch (e) {
                      _thresholdsRight[index] = null;
                    }
                  },
                ),
                trailing: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (BuildContext context) => updateBloc
                    ),
                  ],
                  child: BlocBuilder(
                    bloc: updateBloc,
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
      double? value = sharedPreferences.getDouble(_thresholdSharedPreferenceKeys[controller.$1]);
      controller.$2.text = (value != null) ? value.toString() : "";
    }
    for(var controller in _thresholdAlertTextFieldControllersRight.indexed) {
      double? value = sharedPreferences.getDouble(_thresholdSharedPreferenceKeys[controller.$1 + 6]);
      controller.$2.text = (value != null) ? value.toString() : "";
    }

    _onAdd = handRepository.onAdd((isRight, row) {
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
          flutterRingTonePlayer.playAlarm();
          isAlarming = true;
        }
      } else {
        if(isAlarming) {
          flutterRingTonePlayer.stop();
          isAlarming = false;
        }
      }
      updateBloc.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}