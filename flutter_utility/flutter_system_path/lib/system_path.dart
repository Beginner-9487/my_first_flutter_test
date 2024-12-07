abstract class SystemPath {
  String get app_download_path_absolute;
  String get app_download_path_relative;

  String get app_document_path_absolute;
  String get app_document_path_relative;

  Future<String> system_asset_path(String asset_path);

  String get system_download_path_absolute;
  String get system_download_path_relative;

  String get temporary_path_absolute;
  String get temporary_path_relative;
}