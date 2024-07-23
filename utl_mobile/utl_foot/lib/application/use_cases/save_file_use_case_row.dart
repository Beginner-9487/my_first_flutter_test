import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/infrastructure/save_file_handler_row.dart';
import 'package:utl_foot/application/use_cases/save_file_use_case.dart';
import 'package:utl_foot/resources/global_variables.dart';

class SaveFileUseCaseRow extends SaveFileUseCase {
  static final _saveFileHandler = SaveFileHandlerRow.getInstance();

  final GlobalVariables _globalVariables;
  FootRepository get _footRepository => _globalVariables.footRepository;
  late final StreamSubscription<FootEntity> onAddEntity;
  late final StreamSubscription<FootRow> onAddRow;

  SaveFileUseCaseRow(this._globalVariables) {
    // onAddEntity = _footRepository.onNewRowAdded((entity) async {
    //   await _saveFileHandler.addDataToFile(entity.rows.last);
    // });
    onAddRow = _footRepository.onNewRowAddedRow((row) async {
      await _saveFileHandler.addDataToFile(row);
    });
    // onAddEntity = _footRepository.onNewRowFinished((entity) async {
    //   // debugPrint("EEEEE1: ${entity.bodyPart}: ${entity.rows.length}: ${entity.rowsFinished.length}");
    //   if(entity.rowsFinished.isNotEmpty) {
    //     // debugPrint("EEEEE2: ${entity.rowsFinished.isNotEmpty}");
    //     await _saveFileHandler.addDataToFile(entity.rowsFinished.last);
    //   }
    // });
    // onAddRow = _footRepository.onNewRowFinishedRow((row) async {
    //   await _saveFileHandler.addDataToFile(row);
    // });
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