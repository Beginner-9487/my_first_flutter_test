import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:path_provider/path_provider.dart';

class SystemPathImpl implements SystemPath {
  late Directory? _system_download_directory;
  late Directory? _application_documents_directory;
  late Directory? _external_storage_directory;
  late Directory? _downloads_directory;
  late Directory? _temporary_directory;

  static SystemPathImpl? _instance;
  static Future<SystemPathImpl> getInstance() async {
    if(_instance != null) {
      return _instance!;
    }
    _instance = SystemPathImpl._();
    try {
      if (Platform.isIOS) {
        _instance!._system_download_directory = await getApplicationDocumentsDirectory();
      } else {
        _instance!._system_download_directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await _instance!._system_download_directory!.exists()) {
          _instance!._system_download_directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      debugPrint("Cannot get _application_documents_directory");
    }
    _instance!._application_documents_directory = await getApplicationDocumentsDirectory();
    _instance!._external_storage_directory = await getExternalStorageDirectory();
    _instance!._downloads_directory = await getDownloadsDirectory();
    _instance!._temporary_directory = await getTemporaryDirectory();
    return _instance!;
  }
  SystemPathImpl._();

  @override
  String get app_document_path_absolute => (_application_documents_directory != null)
      ? _application_documents_directory!.absolute.path
      : "";

  @override
  String get app_document_path_relative => (_application_documents_directory != null)
      ? _application_documents_directory!.path
      : "";

  @override
  String get app_download_path_absolute => (_external_storage_directory != null)
      ? _external_storage_directory!.absolute.path
      : "";

  @override
  String get app_download_path_relative => (_external_storage_directory != null)
      ? _external_storage_directory!.path
      : "";

  @override
  Future<String> system_asset_path(String asset_path) async {
    final find = '/';
    final replaceWith = '-';
    final temporaryAssetPath = asset_path.replaceAll(find, replaceWith);
    final tempFile = File("$temporary_path_relative/$temporaryAssetPath");
    if(!(await tempFile.exists())) {
      final byteData = await rootBundle.load(asset_path);
      await tempFile
          .writeAsBytes(byteData
            .buffer
            .asUint8List(
              byteData.offsetInBytes,
              byteData.lengthInBytes),
          );
    }
    return tempFile.absolute.path;
  }

  @override
  String get system_download_path_absolute => (_system_download_directory != null)
      ? _system_download_directory!.absolute.path
      : "";

  @override
  String get system_download_path_relative => (_system_download_directory != null)
      ? _system_download_directory!.path
      : "";

  @override
  String get temporary_path_absolute => (_temporary_directory != null)
      ? _temporary_directory!.absolute.path
      : "";

  @override
  String get temporary_path_relative => (_temporary_directory != null)
      ? _temporary_directory!.path
      : "";
}