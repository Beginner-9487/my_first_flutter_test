import 'dart:async';

import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_file_handler/row_csv_file_impl.dart';
import 'package:flutter_system_path/system_path.dart';

abstract class SaveFileHandler<Data> {
  DateTime get currentTime {
    return DateTime.now();
  }
  String get timeStampFormatString {
    return "${currentTime.year.toString().padLeft(4, '0')}-${currentTime.month.toString().padLeft(2, '0')}-${currentTime.day.toString().padLeft(2, '0')}-${currentTime.hour.toString().padLeft(2, '0')}-${currentTime.minute.toString().padLeft(2, '0')}-${currentTime.second.toString().padLeft(2, '0')}";
  }
  String get timeStampFormatStringForContent {
    return "$timeStampFormatString-${currentTime.millisecond.toString().padLeft(3, '0')}${currentTime.microsecond.toString().padLeft(3, '0')}";
  }
  static final _factory = RowCSVFileHandlerImpl.getInstance();

  SystemPath get systemPath;
  String get _savedFolder => systemPath.system_download_path_absolute;

  static const String _extension = ".csv";

  late String _fileNameLeft;
  late String _fileNameRight;
  late String _filePathLeft;
  late String _filePathRight;
  late RowCSVFile fileLeft;
  late RowCSVFile fileRight;

  bool isFileBeenCreated = false;
  initFile() async {
    _fileNameLeft = "hand_left_$timeStampFormatString";
    _filePathLeft = '$_savedFolder/$_fileNameLeft$_extension';
    _fileNameRight = "hand_right_$timeStampFormatString";
    _filePathRight = '$_savedFolder/$_fileNameRight$_extension';
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