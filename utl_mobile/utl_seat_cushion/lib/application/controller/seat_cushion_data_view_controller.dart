import 'package:utl_seat_cushion/application/user_file_handler.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Controller for managing and exposing seat cushion data to the view
abstract class SeatCushionDataViewController {
  void toggleSavingState();
  bool get isSaving;
  Stream<bool> get isSavingStream;
  SeatCushionEntity? get buffer;
  Stream<SeatCushionEntity> get bufferStream;
  Future<bool> downloadCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  });
  Future<bool> sendCommand({
    required String command,
  });
  Future<bool> clearOldData();
}

/// Controller for managing and exposing seat cushion data to the view
class ConcreteSeatCushionDataViewController extends SeatCushionDataViewController {
  ConcreteSeatCushionDataViewController({
    required this.deleteSeatCushionUseCase,
    required this.fetchSeatCushionUseCase,
    required this.fileHandler,
    required this.saveSeatCushionUseCase,
    required this.seatCushionDeviceUseCase,
  });
  /// Buffer containing the latest seat cushion data
  final DeleteSeatCushionUseCase deleteSeatCushionUseCase;
  final FetchSeatCushionUseCase fetchSeatCushionUseCase;
  final SaveSeatCushionUseCase saveSeatCushionUseCase;
  final SeatCushionDeviceUseCase seatCushionDeviceUseCase;
  final FileHandler fileHandler;
  @override
  void toggleSavingState() {
    saveSeatCushionUseCase.options = SeatCushionSaveOptions(
      saveToBufferOption: true,
      saveToDatabaseOption: !saveSeatCushionUseCase.options.saveToDatabaseOption,
    );
  }
  @override
  bool get isSaving => saveSeatCushionUseCase.options.saveToDatabaseOption;
  @override
  Stream<bool> get isSavingStream => saveSeatCushionUseCase.optionsStream.map((options) => options.saveToDatabaseOption);
  /// Get the current data from the buffer
  @override
  SeatCushionEntity? get buffer => fetchSeatCushionUseCase.buffer;
  @override
  Stream<SeatCushionEntity> get bufferStream => fetchSeatCushionUseCase.bufferStream;
  @override
  Future<bool> downloadCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  }) async {
    return fileHandler.downloadSeatCushionCsvFile(
      folder: folder,
      appLocalizations: appLocalizations,
    );
  }
  @override
  Future<bool> sendCommand({
    required String command,
  }) => seatCushionDeviceUseCase.sendCommand(command: command);
  @override
  Future<bool> clearOldData() {
    return deleteSeatCushionUseCase.clearAllEntities();
  }
}
