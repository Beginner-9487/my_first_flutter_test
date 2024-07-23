import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_foot/application/infrastructure/check_ble_packet.dart';
import 'package:utl_foot/application/infrastructure/save_file_handler_raw.dart';
import 'package:utl_foot/application/use_cases/save_file_use_case.dart';
import 'package:utl_foot/resources/ble_uuid.dart';
import 'package:utl_foot/resources/global_variables.dart';

class SaveFileUseCaseRaw extends SaveFileUseCase {
  static final _saveFileHandler = SaveFileHandlerRaw.getInstance();

  final GlobalVariables _globalVariables;
  BLERepository get _bleRepository => _globalVariables.bleRepository;
  late final BLEPacketListener _blePacketListener;

  SaveFileUseCaseRaw(this._globalVariables) {
    _blePacketListener = BLEPacketListener(
        bleRepository: _bleRepository,
        outputCharacteristicUUID: OUTPUT_UUID,
        onReceivedPacket: _onReceivedPacket
    );
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

  _onReceivedPacket(BLECharacteristic bleCharacteristic, BLEPacket packet) async {
    if(isSavingFile && CheckBLEPacketFoot.isPacketCorrect(packet)) {
      await _saveFileHandler.addDataToFile(packet.raw);
    }
  }
}