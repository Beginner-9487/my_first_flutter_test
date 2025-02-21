import 'package:flutter_basic_utils/basic/time_utils.dart';
import 'package:flutter_file_utils/csv/simple_csv_file.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:synchronized/synchronized.dart';
import 'package:utl_seat_cushion/domain/model/entity/seat_cushion_entity.dart';

class SeatCushionCsvFile {
  static String _generateTimeFileFormat() {
    var time = DateTime.now();
    return time.toFileFormat();
  }
  static String _generateCsvFileName({
    required AppLocalizations appLocalizations,
  }) {
    return "${appLocalizations.seatCushion}_${_generateTimeFileFormat()}";
  }
  final SimpleCsvFile _file;
  SeatCushionCsvFile({
    required String folder,
    required AppLocalizations appLocalizations,
  }) : _file = SimpleCsvFile(path: "$folder/${_generateCsvFileName(appLocalizations: appLocalizations)}.csv");
  final Lock _lock = Lock();
  Future<bool> clearThenGenerateHeader({
    required AppLocalizations appLocalizations,
  }) {
    return _lock.synchronized(() async {
      try{
        await _file.clear(bom: true);
        await _file.writeAsString(
          data: [
            appLocalizations.deviceId,
            appLocalizations.type,
            ...Iterable.generate(
              SeatCushionEntity.forceLength,
                  (index) => "${appLocalizations.force}${index.toString().padLeft(3, "0")}",
            ),
          ],
        );
        return true;
      } catch(e) {
        return false;
      }
    });
  }
  Future<bool> writeEntity({
    required SeatCushionEntity entity,
  }) {
    return _lock.synchronized(() async {
      try {
        await _file.writeAsString(
          data: [
            entity.deviceId,
            entity.type.name,
            ...Iterable.generate(entity.forces.length, (index) => entity.forces.skip(index).first.toString()),
          ],
        );
        return true;
      } catch(e) {
        return false;
      }
    });
  }
}
