import 'package:flutter_file_handler/application/row_csv_file.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/infrastructure/save_file_handler.dart';

class SaveFileHandlerRaw extends SaveFileHandler<List<int>> {
  SaveFileHandlerRaw._();
  static SaveFileHandlerRaw? _instance;
  static SaveFileHandlerRaw getInstance() {
    _instance ??= SaveFileHandlerRaw._();
    return _instance!;
  }

  @override
  addDataToFile(List<int> data) async {
    if(!isFileBeenCreated) {
      return;
    }
    late RowCSVFile file;
    switch(data[0]) {
      case BodyPart.LEFT_FOOT:
        file = fileLeft;
        break;
      case BodyPart.RIGHT_FOOT:
        file = fileRight;
        break;
    }
    await file.write(
        [
          timeStampFormatStringForContent,
          ...data
              .map((e) => e.toRadixString(16).padLeft(2, '0'))
              .toList(),
        ]
    );
  }
}