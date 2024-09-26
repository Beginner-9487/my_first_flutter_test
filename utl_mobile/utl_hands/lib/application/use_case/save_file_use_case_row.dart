import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/infrastructure/save_file_handler_row.dart';
import 'package:utl_hands/application/use_case/save_file_use_case.dart';
import 'package:utl_hands/resources/global_variable.dart';

class SaveFileUseCaseRow extends SaveFileUseCase {
  static final _saveFileHandler = SaveFileHandlerRow.getInstance();

  HandRepository get _handRepository => GlobalVariables.handRepository;
  late final StreamSubscription<(bool, HandRow)> onAddRow;

  SaveFileUseCaseRow() {
    onAddRow = _handRepository.onAdd((isRight, row) async {
      await _saveFileHandler.addDataToFile(row);
    });
    _isSavingFileStateChange = StreamController.broadcast();
  }

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