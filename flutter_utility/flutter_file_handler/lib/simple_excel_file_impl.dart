import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_file_handler/simple_excel_file.dart';

class SimpleExcelFileHandlerImpl implements SimpleExcelFileHandler {
  static SimpleExcelFileHandlerImpl? _instance;
  static SimpleExcelFileHandlerImpl getInstance() {
    _instance ??= SimpleExcelFileHandlerImpl._();
    return _instance!;
  }
  SimpleExcelFileHandlerImpl._();

  @override
  Future<SimpleExcelFile> createEmptyFile(String path) async {
    return SimpleExcelFileImpl._(
      File(path),
      Excel.createExcel(),
    );
  }

  @override
  Future<SimpleExcelFile> openFile(String path) async {
    File file = File(path);
    return file
      .readAsBytes()
      .then((value) {
        Excel excel = Excel.decodeBytes(value.toList());
        return SimpleExcelFileImpl._(
          File(path),
          excel,
        );
      });
  }
}

class SimpleExcelFileImpl implements SimpleExcelFile {
  final File _file;
  final Excel _excel;
  SimpleExcelFileImpl._(
      this._file,
      this._excel,
  );

  @override
  String get path => _file.path;

  @override
  Iterable<SimpleExcelSheet> get sheets => _excel
      .sheets
      .entries
      .map((e) => SimpleExcelSheetImpl(this, e.key));

  @override
  Future<void> save({bool flush = false}) async {
    List<int> bytes = (_excel.encode() != null)
        ? _excel.encode()!
        : [];
    return _file
        .writeAsBytes(bytes, flush: flush)
        .then((value) => null);
  }

  @override
  SimpleExcelSheet createNewSheet(String name) {
    _excel[name];
    return SimpleExcelSheetImpl(this, name);
  }

  @override
  void deleteSheetByIndex(int index) {
    SimpleExcelSheet? sheet = getSheetByIndex(index);
    if(sheet != null) {
      _excel.delete(sheet.name);
    }
  }

  @override
  void deleteSheetByName(String name) {
    _excel.delete(name);
  }

  @override
  SimpleExcelSheet? getSheetByIndex(int index) {
    return sheets.skip(index).firstOrNull;
  }

  @override
  SimpleExcelSheet? getSheetByName(String name) {
    return sheets
      .where((element) => element.name == name)
      .firstOrNull;
  }
}

class SimpleExcelSheetImpl implements SimpleExcelSheet {
  final SimpleExcelFileImpl _fileImpl;
  Sheet? get _sheet {
      return _fileImpl
          ._excel
          .sheets
          .entries
          .where((element) => element.key == name)
          .map((e) => e.value)
          .firstOrNull;
  }
  SimpleExcelSheetImpl(this._fileImpl, this.name);

  @override
  int get index {
    int? index = _fileImpl
        .sheets
        .indexed
        .where((element) => element.$2.name == name)
        .map((e) => e.$1)
        .firstOrNull;
    return (index != null)
        ? index
        : -1;
  }

  @override
  int get rowsLength {
    if(_sheet == null) {
      return -1;
    }
    return _sheet!.rows.length;
  }

  @override
  int columnsLength(int row) {
    if(_sheet == null) {
      return -1;
    }
    if(row >= rowsLength) {
      return -1;
    }
    return _sheet!.row(row).length;
  }

  @override
  String name;

  CellIndex _getCellIndex(int row, int column) {
    return CellIndex.indexByColumnRow(
      columnIndex: column,
      rowIndex: row,
    );
  }

  String _dataToString(Data? data) {
    if(data == null) {
      return "";
    }
    if(data.value == null) {
      return "";
    }
    return data.value.toString();
  }

  @override
  String read(int row, int column) {
    if(_sheet == null) {
      return "";
    }
    return _dataToString(_sheet!.cell(_getCellIndex(row, column)));
  }

  @override
  Iterable<String> readRegion(Iterable<(int row, int column)> region) {
    if(_sheet == null) {
      return [];
    }
    return region
        .map((e) => read(e.$1, e.$2));
  }

  @override
  Iterable<String> readRow(int row) {
    if(_sheet == null) {
      return [];
    }
    if(row >= rowsLength) {
      return [];
    }
    return _sheet!
        .row(row)
        .map((e) => _dataToString(e));
  }

  @override
  void write(int row, int column, String data) {
    if(_sheet == null) {
      return;
    }
    _sheet!
        .cell(_getCellIndex(row, column))
        .value = TextCellValue(data);
  }

  @override
  void writeRegion(Iterable<(int row, int column, String string)> data) {
    for(var d in data) {
      write(d.$1, d.$2, d.$3);
    }
  }

  @override
  void writeRow(int row, Iterable<String> data) {
    for(var d in data.indexed) {
      write(row, d.$1, d.$2);
    }
  }
}