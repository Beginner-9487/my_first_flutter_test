abstract class SimpleExcelFileHandler {
  Future<SimpleExcelFile> createEmptyFile(String path);
  Future<SimpleExcelFile> openFile(String path);
}

abstract class SimpleExcelFile<Sheet> {
  String get path;
  Iterable<SimpleExcelSheet> get sheets;
  SimpleExcelSheet createNewSheet(String name);
  void deleteSheetByIndex(int index);
  void deleteSheetByName(String name);
  SimpleExcelSheet? getSheetByIndex(int index);
  SimpleExcelSheet? getSheetByName(String name);
  Future<void> save({bool flush = false});
}

abstract class SimpleExcelSheet {
  String get name;
  int get index;
  int get rowsLength;
  int columnsLength(int row);
  String read(int row, int column);
  Iterable<String> readRegion(Iterable<(int row, int column)> region);
  Iterable<String> readRow(int row);
  void write(int row, int column, String data);
  void writeRegion(Iterable<(int row, int column, String string)> data);
  void writeRow(int row, Iterable<String> data);
}