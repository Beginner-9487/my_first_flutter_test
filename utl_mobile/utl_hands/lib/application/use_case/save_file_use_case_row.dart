import 'dart:async';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/infrastructure/save_file_handler_row.dart';
import 'package:utl_hands/application/use_case/save_file_use_case.dart';

class SaveFileUseCaseRow extends SaveFileUseCase {
  SaveFileUseCaseRow._(
      this.systemPath,
      this.provider,
      this.handRepository,
  ) {
    onAddRow = handRepository.onAdd((isRight, row) async {
      await _saveFileHandler.addDataToFile(row);
    });
    _isSavingFileStateChange = StreamController.broadcast();
    _saveFileHandler = SaveFileHandlerRow.getInstance(
      systemPath,
      provider,
    );
  }
  SystemPath systemPath;
  BT_Provider provider;
  static SaveFileUseCaseRow? _instance;
  static SaveFileUseCaseRow getInstance(
      SystemPath systemPath,
      BT_Provider provider,
      HandRepository handRepository,
  ) {
    _instance ??= SaveFileUseCaseRow._(
      systemPath,
      provider,
      handRepository,
    );
    return _instance!;
  }


  late final _saveFileHandler;

  HandRepository handRepository;
  late final StreamSubscription<(bool, HandRow)> onAddRow;

  late StreamController<bool> _isSavingFileStateChange;
  @override
  StreamSubscription<bool> onSavingFile(void Function(bool state) doSomething) {
    return _isSavingFileStateChange.stream.listen(doSomething);
  }

  @override
  bool get isSavingFile => _saveFileHandler.isFileBeenCreated;

  @override
  startSavingFile() async {
    if(isSavingFile) {
      return;
    }
    await _saveFileHandler.createFile();
    _isSavingFileStateChange.sink.add(isSavingFile);
  }

  @override
  stopSavingFile() async {
    if(!isSavingFile) {
      return;
    }
    await _saveFileHandler.closeFile();
    _isSavingFileStateChange.sink.add(isSavingFile);
  }
}