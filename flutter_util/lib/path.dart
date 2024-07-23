import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Path {
  static Future<String> get systemDownloadPath async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      debugPrint("Cannot get download folder path");
    }
    return (directory != null) ? directory.absolute.path : "";
  }
  static Future<String> get appDownloadPath async {
    final directory = await getExternalStorageDirectory();
    return (directory != null) ? directory.absolute.path : "";
  }
  static Future<String> get appDocumentPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  static Future<String> get appDownloadPath2 async {
    final directory = await getDownloadsDirectory();
    return (directory != null) ? directory.path : "";
  }
  static Future<String> get temporaryDirectory async {
    final directory = await getTemporaryDirectory();
    return (directory != null) ? directory.path : "";
  }
  static Future<String> assetPath(String assetPath) async {
    final find = '/';
    final replaceWith = '-';
    final temporaryAssetPath = assetPath.replaceAll(find, replaceWith);
    final tempFile = File("${await temporaryDirectory}/$temporaryAssetPath");
    if(!(await tempFile.exists())) {
      final byteData = await rootBundle.load(assetPath);
      final file = await tempFile.writeAsBytes(
        byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
    return tempFile.absolute.path;
  }
}