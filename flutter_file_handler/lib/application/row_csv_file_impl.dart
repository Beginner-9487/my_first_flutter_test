import 'dart:io';
import 'dart:isolate';

import 'package:flutter_file_handler/application/row_csv_file.dart';

class RowCSVFileFactoryImpl extends RowCSVFileFactory {
  @override
  createEmptyFile(String path) async {
    RowCSVFileImpl file = RowCSVFileImpl._(
        File(path)
    );
    return file;
  }

  @override
  Future<RowCSVFile> readFile(String path) {
    // TODO: implement readFile
    throw UnimplementedError();
  }
}

class RowCSVFileFactoryImplWithBOM extends RowCSVFileFactoryImpl {
  @override
  createEmptyFile(String path) async {
    RowCSVFileImpl file = await super.createEmptyFile(path) as RowCSVFileImpl;
    file._file.writeAsBytesSync([0xef, 0xbb, 0xbf]);
    return file;
  }
}

class RowCSVFileImpl extends RowCSVFile {
  final File _file;
  @override
  String get path => _file.path;

  RowCSVFileImpl._(this._file);

  @override
  int index = 0;

  static const String _delimitersColumn = ",";
  static const String _delimitersRow = "\n";

  @override
  write(List<String> data) async {
    // await _saveDataToFileInBackground(_file, data.reduce((value, element) => "$value$_delimitersColumn$element") + _delimitersRow);
    await _file.writeAsString(
      data.reduce((value, element) => "$value$_delimitersColumn$element") + _delimitersRow,
      mode: FileMode.append,
      flush: true,
    );
  }
}

Future<void> _saveDataToFileInBackground(File file, String content) async {
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
  String content = params["content"];
  SendPort sendPort = params["sendPort"];

  // Save data to a file in the background
  file.writeAsString(
    content,
    mode: FileMode.append,
    flush: true,
  );

  // Send the file path back to the main isolate
  sendPort.send(file);
}