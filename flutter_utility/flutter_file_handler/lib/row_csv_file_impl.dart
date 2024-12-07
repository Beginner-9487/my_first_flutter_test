import 'dart:io';

import 'package:flutter_file_handler/row_csv_file.dart';

class RowCSVFileHandlerImpl implements RowCSVFileHandler {
  static RowCSVFileHandlerImpl? _instance;
  static RowCSVFileHandlerImpl getInstance() {
    _instance ??= RowCSVFileHandlerImpl._();
    return _instance!;
  }
  RowCSVFileHandlerImpl._();

  static List<int> _bom(bool b) => b ? [0xef, 0xbb, 0xbf] : [];

  @override
  Future<RowCSVFile> createEmptyFile(String path, {bool bom = false}) async {
    RowCSVFileImpl file = RowCSVFileImpl._(
      File(path),
    );
    return file._file.writeAsBytes(
      _bom(bom),
      mode: FileMode.write,
      flush: true,
    ).then((value) => file);
  }

  @override
  Future<RowCSVFile> openFile(String path) async {
    RowCSVFileImpl file = RowCSVFileImpl._(
      File(path),
    );
    return file.read().then((value) {
      file.index = value.length;
      return file;
    });
  }
}

class RowCSVFileImpl implements RowCSVFile {
  final File _file;
  @override
  String get path => _file.path;

  RowCSVFileImpl._(this._file);

  static String _bom(bool b) => String.fromCharCodes(RowCSVFileHandlerImpl._bom(b));

  @override
  int index = 0;

  static const String _DELIMITER_COLUMN = ",";
  static const String _DELIMITER_ROW = "\n";

  @override
  Future<void> clear({bool flush = false, bool bom = false}) {
    return _file
        .writeAsString(
          _bom(bom),
          mode: FileMode.append,
          flush: flush,
        )
        .then((value) {
          index++;
        });
  }

  @override
  Future<void> write(Iterable<String> data, {bool flush = false}) async {
    late String string;
    switch(data.length) {
      case 0:
        string = _DELIMITER_ROW;
        break;
      case 1:
        string = data.first + _DELIMITER_ROW;
        break;
      default:
        string = data.reduce((value, element) => "$value$_DELIMITER_COLUMN$element") + _DELIMITER_ROW;
    }
    return _file
        .writeAsString(
          string,
          mode: FileMode.append,
          flush: flush,
        )
        .then((value) {
          index++;
        });
  }

  @override
  Future<Iterable<Iterable<String>>> read() async {
    return _file
        .readAsString()
        .then((value) => value
          .split(_DELIMITER_ROW)
          .map((e) => e.split(_DELIMITER_COLUMN))
    );
  }
}