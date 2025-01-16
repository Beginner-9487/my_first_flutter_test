import 'package:async_locks/async_locks.dart';
import 'package:flutter_basic_utils/basic/time_utils.dart';
import 'package:flutter_file_utils/csv/simple_csv_file.dart';
import 'package:utl_seat_cushion/domain/entities/seat_cushion_entity.dart';
import 'package:utl_seat_cushion/domain/use_case/seat_cushion_use_case.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class FileHandler {
  Future<bool> downloadSeatCushionCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  });
}

class ConcreteFileHandler implements FileHandler {
  final FetchSeatCushionUseCase fetchSeatCushionUseCase;
  String generateTimeFileFormat() {
    var time =  DateTime.now();
    return time.toFileFormat();
  }
  String generateCsvFileName({
    required AppLocalizations appLocalizations,
  }) {
    return "${appLocalizations.seatCushion}_${generateTimeFileFormat()}";
  }
  SimpleCsvFile createNewCsvFile({
    required String folder,
    required String fileName,
  }) {
    return SimpleCsvFile(path: "$folder/$fileName.csv");
  }
  ConcreteFileHandler({
    required this.fetchSeatCushionUseCase,
  });
  Lock fileWriterLock = Lock();
  @override
  Future<bool> downloadSeatCushionCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  }) async {
    try {
      var file = createNewCsvFile(
        folder: folder,
        fileName: generateCsvFileName(appLocalizations: appLocalizations),
      );
      await file.clear(bom: true);
      await file.writeAsString(
        data: [
          appLocalizations.deviceId,
          appLocalizations.type,
          ...Iterable.generate(
            SeatCushionEntity.forceLength,
            (index) => "${appLocalizations.force}${index.toString().padLeft(3, "0")}",
          ),
        ],
      );
      bool flag = true;
      await fetchSeatCushionUseCase.handleEntities(
        start: 0,
        end: await fetchSeatCushionUseCase.fetchEntitiesLength(),
        handler: (entity) async {
          if(!flag) return;
          fileWriterLock.run(() async {
            try {
              await file.writeAsString(
                data: [
                  entity.deviceId,
                  entity.type.name,
                  ...Iterable.generate(entity.forces.length, (index) => entity.forces.skip(index).first.toString()),
                ],
              );
            } catch(e) {
              flag = false;
            }
          });
        },
      );
      try {
        await fileWriterLock.acquire();
        return flag;
      } catch(e) {
        return false;
      } finally {
        fileWriterLock.release();
      }
    } catch(e) {
      return false;
    }
  }
  void dispose() {
    fileWriterLock.cancelAll();
  }
}
