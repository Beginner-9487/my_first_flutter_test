import 'package:synchronized/synchronized.dart';
import 'package:utl_seat_cushion/domain/usecase/seat_cushion_usecase.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_seat_cushion/infrastructure/source/csv_file/seat_cushion_csv_file.dart';

abstract class FileService {
  Future<bool> downloadSeatCushionCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  });
}

class ConcreteFileService implements FileService {
  final HandleSeatCushionEntitiesUseCase handleSeatCushionEntitiesUseCase;
  final FetchSeatCushionEntitiesLengthUseCase fetchSeatCushionEntitiesLengthUseCase;
  ConcreteFileService({
    required this.handleSeatCushionEntitiesUseCase,
    required this.fetchSeatCushionEntitiesLengthUseCase,
  });
  @override
  Future<bool> downloadSeatCushionCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  }) async {
    var file = SeatCushionCsvFile(
      folder: folder,
      appLocalizations: appLocalizations,
    );
    await file.clearThenGenerateHeader(appLocalizations: appLocalizations);
    bool flag = true;
    Lock lock = Lock();
    await handleSeatCushionEntitiesUseCase(
      start: 0,
      end: await fetchSeatCushionEntitiesLengthUseCase(),
      handler: (entity) async {
        lock.synchronized(() async {
          if(!flag) return;
          flag = await file.writeEntity(entity: entity);
        });
      },
    );
    return lock.synchronized(() => flag);
  }
}
