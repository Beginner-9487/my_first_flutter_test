abstract class SimpleExcelFileFactory {
  Future<SimpleExcelFile> createEmptyFile(String path);
  Future<SimpleExcelFile> readFile(String path);
}

abstract class SimpleExcelFile<Sheet> {
  String get path;
  List<SimpleExcelSheet> get sheets;
  SimpleExcelSheet createNewSheet(String name);
  deleteSheetByIndex(int index);
  deleteSheetByName(String name);
  SimpleExcelSheet getSheetByIndex(int index);
  SimpleExcelSheet getSheetByName(String name);
  Future<bool> save();
}

abstract class SimpleExcelSheet {
  String get name;
  int get index;
  int get rowsLength;
  int columnsLength(int row);
  String read(int row, int column);
  List<String> readRegion(List<(int, int)> region) {
    List<String> data = [];
    for((int, int) rc in region) {
      data.add(read(rc.$1, rc.$2));
    }
    return data;
  }
  write(int row, int column, String data);
  List<String> readRow(int row);
  writeRow(int row, List<String> data);
  writeRegion(List<List<String?>> data) {
    for((int, List<String?>) row in data.indexed) {
      for((int, String?) column in row.$2.indexed) {
        if(column.$2 != null) {
          write(row.$1, column.$1, column.$2!);
        }
      }
    }
  }
}