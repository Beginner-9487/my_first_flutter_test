import 'dart:async';

import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_amulet/application/infrastructure/amulet_file_handler.dart';
import 'package:utl_amulet/application/infrastructure/amulet_file_handler_impl.dart';

class AutoSaveFileServiceAmulet {
  static AutoSaveFileServiceAmulet? _instance;
  static AutoSaveFileServiceAmulet getInstance(AmuletRepository amuletRepository) {
    _instance ??= AutoSaveFileServiceAmulet._(
      amuletRepository,
    );
    return _instance!;
  }

  final AmuletRepository _repository;
  late final AmuletFileHandler _fileHandler;
  late StreamSubscription _onAdd;

  AutoSaveFileServiceAmulet._(this._repository) {
    _fileHandler = AmuletFileHandlerImpl();
    _onAdd = _repository.onAdd((AmuletRow row) {
      _fileHandler.addDataToFile(row);
    });
  }
}