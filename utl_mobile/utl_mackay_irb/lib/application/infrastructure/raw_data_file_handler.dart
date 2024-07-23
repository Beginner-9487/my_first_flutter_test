import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_file_handler/application/row_csv_file.dart';
import 'package:flutter_file_handler/application/row_csv_file_impl.dart';
import 'package:flutter_util/path.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';

class RawDataFileHandler {
  DateTime get _initTime {
    return GlobalVariables.instance.initTimeStamp;
  }
  DateTime get _currentTime {
    return DateTime.now();
  }
  String get _timeStampFormatString {
    return "${_currentTime.year.toString().padLeft(4, '0')}-${_currentTime.month.toString().padLeft(2, '0')}-${_currentTime.day.toString().padLeft(2, '0')}-${_currentTime.hour.toString().padLeft(2, '0')}-${_currentTime.minute.toString().padLeft(2, '0')}-${_currentTime.second.toString().padLeft(2, '0')}";
  }
  String get _timeStampFormatStringForContent {
    return "$_timeStampFormatString-${_currentTime.millisecond.toString().padLeft(3, '0')}${_currentTime.microsecond.toString().padLeft(3, '0')}";
  }
  static final _factory = RowCSVFileFactoryImplWithBOM();
  Future<String> get _savedFolder async => await Path.systemDownloadPath;

  static const String _extension = ".csv";

  Future<String> _fileName(BLECharacteristic bleCharacteristic) async {
    return "mackay_irb_raw_${bleCharacteristic.device.name}_$_timeStampFormatString";
  }
  Future<String> _filePath(BLECharacteristic bleCharacteristic) async {
    return '${await _savedFolder}/${await _fileName(bleCharacteristic)}$_extension';
  }

  List<_FileManager> files = [];

  bool isFileBeenCreated = false;
  Future<_FileManager> initFile(BLECharacteristic bleCharacteristic) async {
    (int, _FileManager)? target = files.indexed.where((element) => element.$2.bleCharacteristic == bleCharacteristic).firstOrNull;
    if(target == null) {
      files.add(_FileManager(
        bleCharacteristic,
        await _factory.createEmptyFile(await _filePath(bleCharacteristic)),
        true,
      ));
    } else {
      files[target.$1].file = await _factory.createEmptyFile(await _filePath(bleCharacteristic));
      files[target.$1].isWriting = true;
    }
    return files.where((element) => element.bleCharacteristic == bleCharacteristic).first;
  }
  Future<_FileManager> _createFile(BLECharacteristic bleCharacteristic) async {
    return await initFile(bleCharacteristic);
  }
  _closeFile(BLECharacteristic bleCharacteristic) async {
    _FileManager? target = files.where((element) => element.bleCharacteristic == bleCharacteristic).firstOrNull;
    if(target != null) {
      target.isWriting = false;
    }
  }
  addDataToFile(BLECharacteristic bleCharacteristic, List<int> data) async {
    _FileManager? target = files.where((element) => element.bleCharacteristic == bleCharacteristic).firstOrNull;
    if(target == null || !target.isWriting) {
      target = await _createFile(bleCharacteristic);
    }
    await target.file.write(
        [
          _timeStampFormatStringForContent,
          ...data
              .map((e) => e.toRadixString(16).padLeft(2, '0'))
              .toList(),
        ]
    );
  }
  finish(BLECharacteristic bleCharacteristic) async {
    await _closeFile(bleCharacteristic);
  }
}

class _FileManager {
  BLECharacteristic bleCharacteristic;
  RowCSVFile file;
  bool isWriting;
  _FileManager(
      this.bleCharacteristic,
      this.file,
      this.isWriting,
  );
}