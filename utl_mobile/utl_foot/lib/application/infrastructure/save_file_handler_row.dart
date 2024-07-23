import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_file_handler/application/row_csv_file.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/domain/foot_sensor_position.dart';
import 'package:utl_foot/application/infrastructure/save_file_handler.dart';
import 'package:utl_foot/resources/global_variables.dart';

class SaveFileHandlerRow extends SaveFileHandler<FootRow> {
  SaveFileHandlerRow._() {
    _setTimer();
  }
  static SaveFileHandlerRow? _instance;
  static SaveFileHandlerRow getInstance() {
    _instance ??= SaveFileHandlerRow._();
    return _instance!;
  }

  _setTimer() {
    Timer(const Duration(milliseconds: 1), () async {
      await _saveFile();
      _setTimer();
    });
  }

  List<String> get _HEADER => [
    R.str.id,
    R.str.time,
    ...List.generate(FootSensorPosition.numberOfFootSensor, (int n) {
      return [
        "${n+1} - ${R.str.magX}",
        "${n+1} - ${R.str.magY}",
        "${n+1} - ${R.str.magZ}",
        // "${n+1} - ${R.str.shearForceX}",
        // "${n+1} - ${R.str.shearForceY}",
        // "${n+1} - ${R.str.shearForceTotal}",
        // "${n+1} - ${R.str.shearForceRadians}",
        // "${n+1} - ${R.str.pressure}",
        "${n+1} - ${R.str.temperature}",
      ];
    }).reduce((value, element) => value..addAll(element)),
    "IMU: ${R.str.accX}",
    "IMU: ${R.str.accY}",
    "IMU: ${R.str.accZ}",
    "IMU: ${R.str.gyroX}",
    "IMU: ${R.str.gyroY}",
    "IMU: ${R.str.gyroZ}",
    "IMU: ${R.str.magX}",
    "IMU: ${R.str.magY}",
    "IMU: ${R.str.magZ}",
    "IMU: ${R.str.pitch}",
    "IMU: ${R.str.roll}",
    "IMU: ${R.str.yaw}",
  ];

  @override
  initFile() async {
    await super.initFile();
    await fileLeft.write(_HEADER);
    await fileRight.write(_HEADER);
  }

  @override
  addDataToFile(FootRow data) async {
    if(!isFileBeenCreated) {
      return;
    }
    switch(data.bodyPart) {
      case BodyPart.LEFT_FOOT:
        buffer.add((fileLeft, data));
        break;
      case BodyPart.RIGHT_FOOT:
        buffer.add((fileRight, data));
        break;
    }
  }

  List<String> _footRowToFileFormat(FootRow row) {
    return [
      row.rowId.toString(),
      timeStampFormatStringForContent,
      ...List.generate(FootSensorPosition.numberOfFootSensor, (int n) {
        return [
          row.sensorsData[n].magX.toString(),
          row.sensorsData[n].magY.toString(),
          row.sensorsData[n].magZ.toString(),
          // row.sensorsData[n].shearForceX.toString(),
          // row.sensorsData[n].shearForceY.toString(),
          // row.sensorsData[n].shearForceTotal.toString(),
          // row.sensorsData[n].shearForceRadians.toString(),
          // row.sensorsData[n].pressure.toString(),
          row.sensorsData[n].temperature.toString(),
        ];
      }).reduce((value, element) => value..addAll(element)),
      row.accX.toString(),
      row.accY.toString(),
      row.accZ.toString(),
      row.gyroX.toString(),
      row.gyroY.toString(),
      row.gyroZ.toString(),
      row.magX.toString(),
      row.magY.toString(),
      row.magZ.toString(),
      row.pitch.toString(),
      row.roll.toString(),
      row.yaw.toString(),
    ];
  }

  List<(RowCSVFile, FootRow)> buffer = [];
  /// Make sure that both footLeft and footRight files have the same length.
  @override
  _saveFile() async {
    if(!isFileBeenCreated) {
      return;
    }
    int maxLength = buffer.length;
    int finalLength = 0;
    (RowCSVFile, FootRow)? buffer1;
    for(int i=0; i<maxLength; i++) {
      // if(i>=buffer.length) {
      //   break;
      // }
      if(GlobalVariables.instance.bleRepository.connectedDevices.length == 1) {
        await buffer[i].$1.write(_footRowToFileFormat(buffer[i].$2));
        continue;
      }
      if(buffer1 == null) {
        buffer1 = buffer[i];
        // debugPrint("buffer1: ${buffer1.$2.bodyPart}");
      } else if(buffer1.$1 != buffer[i].$1) {
        finalLength = i;
        await buffer1.$1.write(_footRowToFileFormat(buffer1.$2));
        await buffer[i].$1.write(_footRowToFileFormat(buffer[i].$2));
        // debugPrint("buffer[i]: $i, ${buffer[i].$2.bodyPart}");
        buffer1 = null;
      }
    }
    buffer.removeRange(0, finalLength);
  }
}