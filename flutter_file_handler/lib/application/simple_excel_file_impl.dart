import 'dart:io';
import 'dart:isolate';

import 'package:excel/excel.dart';
import 'package:flutter_file_handler/application/simple_excel_file.dart';

class SimpleExcelFileFactoryImpl extends SimpleExcelFileFactory {
  @override
  createEmptyFile(String path) async {
    SimpleExcelFileImpl file = SimpleExcelFileImpl._(path);
    file._file = File(path);
    file._excel = Excel.createExcel();
    return file;
  }
  @override
  readFile(String path) async {
    var file = File(path);
    try {
      Excel excel = Excel.decodeBytes((await file.readAsBytes()).toList());
      SimpleExcelFileImpl excelFile = SimpleExcelFileImpl._(path);
      excelFile._file = file;
      excelFile._excel = excel;
      return excelFile;
    } catch(e) {
      throw Exception("This file is not existed.");
    }
  }
}

class SimpleExcelFileImpl extends SimpleExcelFile {
  late File _file;
  late Excel _excel;
  SimpleExcelFileImpl._(this.path);
  @override
  String path;
  @override
  List<SimpleExcelSheet> sheets = [];
  @override
  save() async {
    _saveDataToFileInBackground(_file, _excel.encode()!);
    return true;
  }
  @override
  createNewSheet(String name) {
    return SimpleExcelSheetImpl(this, _excel, _excel[name]);
  }
  @override
  deleteSheetByIndex(int index) {
    _excel.delete(getSheetByIndex(index).name);
  }
  @override
  deleteSheetByName(String name) {
    _excel.delete(name);
  }
  @override
  getSheetByIndex(int index) {
    if(index < _excel.sheets.length) {
      return SimpleExcelSheetImpl(this, _excel, _excel.sheets.entries.toList()[index].value);
    } else {
      throw Exception("Exceed the sheet number.");
    }
  }
  @override
  getSheetByName(String name) {
    SimpleExcelSheet? sheet = _excel.sheets.entries
        .where((element) => element.key == name)
        .map((e) => SimpleExcelSheetImpl(this, _excel, e.value))
        .firstOrNull;
    if(sheet != null) {
      return sheet;
    } else {
      throw Exception("No such a sheet.");
    }
  }
}

class SimpleExcelSheetImpl extends SimpleExcelSheet {
  SimpleExcelFileImpl fileImpl;
  final Excel _excel;
  final Sheet _sheet;
  SimpleExcelSheetImpl(this.fileImpl, this._excel, this._sheet);

  @override
  int get index => fileImpl._excel.sheets.entries
      .indexed
      .where((element) => element.$2.key == name)
      .map((e) => e.$1)
      .first;

  @override
  String get name => _sheet.sheetName;

  CellIndex _getCellIndex(int row, int column) {
    return CellIndex.indexByColumnRow(
      columnIndex: column,
      rowIndex: row,
    );
  }

  @override
  String read(int row, int column) {
    CellValue? value = _sheet.cell(_getCellIndex(row, column)).value;
    if(value == null) {
      return "";
    } else {
      return value.toString();
    }
  }
  @override
  List<String> readRow(int row) {
    return _sheet.rows[row]
        .map((e) => (e != null && e.value != null) ? e.value!.toString() : "")
        .toList();
  }

  @override
  write(int row, int column, String data) {
    _sheet.cell(_getCellIndex(row, column)).value = TextCellValue(data);
  }

  @override
  writeRow(int row, List<String> data) {
    for(var d in data.indexed) {
      _sheet
          .cell(_getCellIndex(rowsLength, d.$1))
          .value = TextCellValue(d.$2);
    }
  }

  @override
  int get rowsLength => _sheet.rows.length;

  @override
  int columnsLength(int row) {
    if(row < rowsLength) {
      return _sheet.rows[row].length;
    }
    return 0;
  }
}

void _saveDataToFileInBackground(File file, List<int> content) async {
  // Create a ReceivePort to receive messages from the background isolate
  ReceivePort receivePort = ReceivePort();
  // Spawn a new isolate and pass the SendPort of the receive port to it
  await Isolate.spawn(_backgroundSaveFile, {"file": file, "content": content, "sendPort": receivePort.sendPort});

  // Listen for messages from the background isolate
  receivePort.listen((dynamic data) {
    if (data is String) {
      print("Background isolate: $data");
    } else if (data is File) {
      print("File saved successfully: ${data.path}");
    }
  });

  print("Background file saving started.");
}

void _backgroundSaveFile(Map<String, dynamic> params) {
  File file = params["file"];
  List<int> content = params["content"];
  SendPort sendPort = params["sendPort"];

  // Save data to a file in the background
  file.writeAsBytes(content);

  // Send the file path back to the main isolate
  sendPort.send(file);
}