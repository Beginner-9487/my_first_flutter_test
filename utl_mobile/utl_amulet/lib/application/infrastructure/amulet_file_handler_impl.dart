import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_file_handler/application/row_csv_file.dart';
import 'package:flutter_file_handler/application/row_csv_file_impl.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/infrastructure/amulet_file_handler.dart';
import 'package:flutter_util/path.dart';

class AmuletFileHandlerImpl extends AmuletFileHandler {
  AmuletFileHandlerImpl();

  static get _initTimeStampFormatString {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}_${dateTime.hour}-${dateTime.minute}-${dateTime.second}";
  }

  final RowCSVFileFactoryImplWithBOM _factory = RowCSVFileFactoryImplWithBOM();
  static Future<String> get _savedFolder async => await Path.systemDownloadPath;

  static List<String> get _HEADER {
    List<String> header = [
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
    file.write(_HEADER);
    files.add((
      fileName,
      filePath,
      device,
      file,
    ));
  }

  @override
  addDataToFile(AmuletRow row) async {
    if(!isFileBeenCreated(row.device)) {
      await _createFile(row.device);
    }
    List<String> data = [];
    data.add(((row.time * _ROUND).round() / _ROUND).toString());
    data.add(((row.accX * _ROUND).round() / _ROUND).toString());
    data.add(((row.accY * _ROUND).round() / _ROUND).toString());
    data.add(((row.accZ * _ROUND).round() / _ROUND).toString());
    data.add(((row.magX * _ROUND).round() / _ROUND).toString());
    data.add(((row.magY * _ROUND).round() / _ROUND).toString());
    data.add(((row.magZ * _ROUND).round() / _ROUND).toString());
    data.add(((row.gyroX * _ROUND).round() / _ROUND).toString());
    data.add(((row.gyroY * _ROUND).round() / _ROUND).toString());
    data.add(((row.gyroZ * _ROUND).round() / _ROUND).toString());
    data.add(((row.pitch * _ROUND).round() / _ROUND).toString());
    data.add(((row.roll * _ROUND).round() / _ROUND).toString());
    data.add(((row.yaw * _ROUND).round() / _ROUND).toString());
    data.add(((row.gValue * _ROUND).round() / _ROUND).toString());
    await findFileByDevice(row.device).write(data);
  }
}