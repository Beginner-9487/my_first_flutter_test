import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_file_handler/application/row_csv_file.dart';
import 'package:flutter_file_handler/application/row_csv_file_impl.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/infrastructure/amulet_file_handler.dart';
import 'package:flutter_util/path.dart';

class AmuletFileHandlerImpl extends AmuletFileHandler {
  AmuletFileHandlerImpl() {
    _setTimer();
  }

  _setTimer() {
    Timer(const Duration(milliseconds: 1), () async {
      await _saveFile();
      _setTimer();
    });
  }

  static get _initTimeStampFormatString {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}";
  }

  final RowCSVFileFactoryImplWithBOM _factory = RowCSVFileFactoryImplWithBOM();
  static Future<String> get _savedFolder async => await Path.systemDownloadPath;

  static List<String> get _HEADER {
    List<String> header = [
      R.str.id,
      R.str.time,
      R.str.accX,
      R.str.accY,
      R.str.accZ,
      R.str.magX,
      R.str.magY,
      R.str.magZ,
      R.str.gyroX,
      R.str.gyroY,
      R.str.gyroZ,
      R.str.pitch,
      R.str.roll,
      R.str.yaw,
      R.str.gValue,
      R.str.temperature,
      R.str.pressure,
      R.str.posture,
    ];
    return header;
  }

  @override
  readFile(String filePath) async {
    // try {
    //   file = await factory.readFile(filePath);
    //   sheet = file.getSheetByIndex(0);
    // } catch(e) {
    //   debugPrint(e.toString());
    // }
    // for(int r=1; r<sheet.rowsLength; r++) {
    //   if(sheet.read(r, 0) == "") {
    //     continue;
    //   }
    //   int c = 0;
    //   amuletRepository.add(AmuletRow(
    //     time: double.parse(sheet.read(r, c++)),
    //     accX: double.parse(sheet.read(r, c++)),
    //     accY: double.parse(sheet.read(r, c++)),
    //     accZ: double.parse(sheet.read(r, c++)),
    //     gyroX: double.parse(sheet.read(r, c++)),
    //     gyroY: double.parse(sheet.read(r, c++)),
    //     gyroZ: double.parse(sheet.read(r, c++)),
    //     magX: double.parse(sheet.read(r, c++)),
    //     magY: double.parse(sheet.read(r, c++)),
    //     magZ: double.parse(sheet.read(r, c++)),
    //     pitch: double.parse(sheet.read(r, c++)),
    //     roll: double.parse(sheet.read(r, c++)),
    //     yaw: double.parse(sheet.read(r, c++)),
    //     gValue: double.parse(sheet.read(r, c++)),
    //   ));
    // }
  }

  static const int _ROUND = 10000;
  static const String _EXTENSION = ".csv";

  /// File name, File path, Device, File
  final List<(String, String, BLEDevice, RowCSVFile)> files = [];

  bool isFileBeenCreated(BLEDevice device) {
    return files.where((element) => element.$3 == device).isNotEmpty;
  }
  String findFileNameByDevice(BLEDevice device) {
    return files.where((element) => element.$3 == device).first.$1;
  }
  String findFilePathByDevice(BLEDevice device) {
    return files.where((element) => element.$3 == device).first.$2;
  }
  RowCSVFile findFileByDevice(BLEDevice device) {
    return files.where((element) => element.$3 == device).first.$4;
  }

  _createFile(BLEDevice device) async {
    String fileName = "amulet_${device.name}_$_initTimeStampFormatString";
    String filePath = '${await _savedFolder}/$fileName$_EXTENSION';
    RowCSVFile file = await _factory.createEmptyFile(filePath);
    await file.write(_HEADER);
    files.add((
      fileName,
      filePath,
      device,
      file,
    ));
  }

  List<AmuletRow> buffer = [];
  @override
  addDataToFile(AmuletRow row) async {
    // debugPrint("amulet_file_handler_impl.addDataToFile.raw: ${row.time}");
    buffer.add(row);
  }

  _saveFile() async {
    if(buffer.isEmpty) {
      return;
    }
    int length = buffer.length;
    for(int i=0; i<length; i++) {
      if(!isFileBeenCreated(buffer[i].device)) {
        await _createFile(buffer[i].device);
      }
      List<String> data = [];
      data.add(buffer[i].id.toString());
      data.add(((buffer[i].time * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].accX * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].accY * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].accZ * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].magX * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].magY * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].magZ * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].gyroX * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].gyroY * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].gyroZ * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].pitch * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].roll * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].yaw * _ROUND).round() / _ROUND).toString());
      data.add(((buffer[i].gValue * _ROUND).round() / _ROUND).toString());
      data.add((buffer[i].temperature).toString());
      data.add((buffer[i].pressure).toString());
      data.add((buffer[i].posture).toString());
      await findFileByDevice(buffer[i].device).write(data);
    }
    buffer.removeRange(0, length);
  }
}