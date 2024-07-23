import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_file_handler/application/row_csv_file.dart';
import 'package:flutter_file_handler/application/row_csv_file_impl.dart';
import 'package:flutter_util/path.dart';
import 'package:utl_foot/resources/global_variables.dart';

abstract class SaveFileHandler<Data> {

  DateTime get initTime {
    return GlobalVariables.instance.initTimeStamp;
  }
  DateTime get currentTime {
    return DateTime.now();
  }
  String get timeStampFormatString {
    return "${currentTime.year.toString().padLeft(4, '0')}-${currentTime.month.toString().padLeft(2, '0')}-${currentTime.day.toString().padLeft(2, '0')}-${currentTime.hour.toString().padLeft(2, '0')}-${currentTime.minute.toString().padLeft(2, '0')}-${currentTime.second.toString().padLeft(2, '0')}";
  }
  // String get timeStampFormatStringForContent {
  //   return "$timeStampFormatString-${currentTime.millisecond.toString().padLeft(3, '0')}${currentTime.microsecond.toString().padLeft(3, '0')}";
  // }
  String get timeStampFormatStringForContent {
    return "${currentTime.hour.toString().padLeft(2, '0')}-${currentTime.minute.toString().padLeft(2, '0')}-${currentTime.second.toString().padLeft(2, '0')}-$timeStampFormatString-${currentTime.millisecond.toString().padLeft(3, '0')}${currentTime.microsecond.toString().padLeft(3, '0')}";
  }
  static final _factory = RowCSVFileFactoryImplWithBOM();
  Future<String> get _savedFolder async => await Path.systemDownloadPath;

  static const String _extension = ".csv";

  late String _fileNameLeft;
  late String _fileNameRight;
  late String _filePathLeft;
  late String _filePathRight;
  late RowCSVFile fileLeft;
  late RowCSVFile fileRight;

  bool isFileBeenCreated = false;
  initFile() async {
    _fileNameLeft = "foot_left_$timeStampFormatString";
    _filePathLeft = '${await _savedFolder}/$_fileNameLeft$_extension';
    _fileNameRight = "foot_right_$timeStampFormatString";
    _filePathRight = '${await _savedFolder}/$_fileNameRight$_extension';
    fileLeft = await _factory.createEmptyFile(_filePathLeft);
    fileRight = await _factory.createEmptyFile(_filePathRight);
  }
  createFile() async {
    await initFile();
    isFileBeenCreated = true;
  }
  closeFile() async {
    isFileBeenCreated = false;
  }
  addDataToFile(Data data);
}