abstract class RowCSVFileHandler {
  Future<RowCSVFile> createEmptyFile(String path, {bool bom = false});
  Future<RowCSVFile> openFile(String path);
}

abstract class RowCSVFile {
  String get path;
  int get index;
  Future<void> clear({bool flush = false, bool bom = false});
  Future<void> write(Iterable<String> data, {bool flush = false});
  Future<Iterable<Iterable<String>>> read();
}