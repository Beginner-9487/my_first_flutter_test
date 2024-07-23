abstract class RowCSVFileFactory {
  Future<RowCSVFile> createEmptyFile(String path);
  Future<RowCSVFile> readFile(String path);
}

abstract class RowCSVFile {
  String get path;
  int get index;
  write(List<String> data);
}