import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_ble/application/infrastructure/ble_packet_listener.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/infrastructure/mackay_irb_file_handler.dart';
import 'package:utl_mackay_irb/application/infrastructure/mackay_irb_file_handler_impl.dart';
import 'package:utl_mackay_irb/application/infrastructure/raw_data_file_handler.dart';
import 'package:utl_mackay_irb/resources/ble_uuid.dart';

class AutoSaveFileServiceMackayIRB {
  static AutoSaveFileServiceMackayIRB? _instance;
  static AutoSaveFileServiceMackayIRB getInstance(BLERepository bleRepository, MackayIRBRepository mackayIRBRepository) {
    _instance ??= AutoSaveFileServiceMackayIRB._(
      bleRepository,
      mackayIRBRepository,
    );
    return _instance!;
  }
  late final BLEPacketListener blePacketListener;
  late final MackayIRBFileHandler mackayIRBFileHandler;

  final MackayIRBRepository _repository;
  AutoSaveFileServiceMackayIRB._(bleRepository, this._repository) {
    mackayIRBFileHandler = MackayIRBFileHandlerImpl.getInstance();
    onMeasurementFinished = _repository.onEntityFinished((entity) {
      mackayIRBFileHandler.saveMeasurementFile(entity);
      mackayIRBFileHandler.save5sFile(entity);
    });
    rawDataFileHandler = RawDataFileHandler();
    blePacketListener = BLEPacketListener(
        bleRepository: bleRepository,
        outputCharacteristicUUID: OUTPUT_UUID,
        onReceivedPacket: onReceivedPacket
    );
  }
  late final StreamSubscription<MackayIRBEntity> onMeasurementFinished;

  late RawDataFileHandler rawDataFileHandler;
  onReceivedPacket (BLECharacteristic bleCharacteristic, BLEPacket blePacket)  {
    rawDataFileHandler.addDataToFile(bleCharacteristic, blePacket.raw);
  }
}