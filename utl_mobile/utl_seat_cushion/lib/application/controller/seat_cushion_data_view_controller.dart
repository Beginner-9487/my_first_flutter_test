import 'package:utl_seat_cushion/application/user_file_handler.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/repository/seat_cushion_repository.dart';
import 'package:utl_seat_cushion/domain/usecase/seat_cushion_usecase.dart';

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
    required this.fetchLastSeatCushionEntityUseCase,
    required this.fetchLastSeatCushionEntityStreamUseCase,
    required this.clearAllSeatCushionEntitiesUseCase,
    required this.getSeatCushionOptionsStreamUseCase,
    required this.getSeatCushionOptionsUseCase,
    required this.setSeatCushionOptionsUseCase,
    required this.sendCommandToAllSeatCushionDeviceUseCase,
    required this.fileHandler,
  });

  /// Buffer containing the latest seat cushion data
  final FetchLastSeatCushionEntityUseCase fetchLastSeatCushionEntityUseCase;
  final FetchLastSeatCushionEntityStreamUseCase fetchLastSeatCushionEntityStreamUseCase;
  final ClearAllSeatCushionEntitiesUseCase clearAllSeatCushionEntitiesUseCase;
  final GetSeatCushionOptionsStreamUseCase getSeatCushionOptionsStreamUseCase;
  final GetSeatCushionOptionsUseCase getSeatCushionOptionsUseCase;
  final SetSeatCushionOptionsUseCase setSeatCushionOptionsUseCase;
  final SendCommandToAllSeatCushionDeviceUseCase sendCommandToAllSeatCushionDeviceUseCase;
  final FileHandler fileHandler;

  @override
  void toggleSavingState() {
    setSeatCushionOptionsUseCase(
      options: SeatCushionSaveOptions(
        saveToBufferOption: true,
        saveToDatabaseOption: !getSeatCushionOptionsUseCase().saveToDatabaseOption,
      ),
    );
  }
  @override
  bool get isSaving => getSeatCushionOptionsUseCase().saveToDatabaseOption;
  @override
  Stream<bool> get isSavingStream => getSeatCushionOptionsStreamUseCase().map((options) => options.saveToDatabaseOption);
  /// Get the current data from the buffer
  @override
  SeatCushionEntity? get buffer => fetchLastSeatCushionEntityUseCase();
  @override
  Stream<SeatCushionEntity> get bufferStream => fetchLastSeatCushionEntityStreamUseCase();
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
  }) => sendCommandToAllSeatCushionDeviceUseCase(command: command);
  @override
  Future<bool> clearOldData() {
    return clearAllSeatCushionEntitiesUseCase();
  }
}
