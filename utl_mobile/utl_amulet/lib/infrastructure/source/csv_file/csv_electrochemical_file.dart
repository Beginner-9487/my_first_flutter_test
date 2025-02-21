import 'package:flutter_file_utils/csv/simple_csv_file.dart';
import 'package:synchronized/synchronized.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/domain/entity/amulet_entity.dart';

class CsvAmuletFile {
  static String _generateTimeString() {
    DateTime t = DateTime.now();
    return "${t.year.toString().padLeft(2, '0')}"
        "-${t.month.toString().padLeft(2, '0')}"
        "-${t.day.toString().padLeft(2, '0')}"
        "_${t.hour.toString().padLeft(2, '0')}"
        "-${t.minute.toString().padLeft(2, '0')}"
        "-${t.second.toString().padLeft(2, '0')}"
        "_${t.millisecond.toString().padLeft(3, '0')}"
        "${t.microsecond.toString().padLeft(3, '0')}";
  }

  final Lock _lock = Lock();
  final SimpleCsvFile _file;
  CsvAmuletFile({
    required String folderPath,
  }) : _file = SimpleCsvFile(
    path: "$folderPath/Amulet_${_generateTimeString()}.csv",
  );

  Future<bool> clearThenGenerateHeader({
    required AppLocalizations appLocalizations,
  }) {
    return _lock.synchronized(() async {
      try {
        await _file.clear(bom: true);
        await _file.writeAsString(
          data: [
            appLocalizations.id,
            appLocalizations.deviceId,
            appLocalizations.time,
            appLocalizations.accX,
            appLocalizations.accY,
            appLocalizations.accZ,
            appLocalizations.accTotal,
            // appLocalizations.gyroX,
            // appLocalizations.gyroY,
            // appLocalizations.gyroZ,
            // appLocalizations.gyroTotal,
            appLocalizations.magX,
            appLocalizations.magY,
            appLocalizations.magZ,
            appLocalizations.magTotal,
            appLocalizations.pitch,
            appLocalizations.roll,
            appLocalizations.yaw,
            // appLocalizations.gValue,
            appLocalizations.pressure,
            appLocalizations.temperature,
            appLocalizations.posture,
            appLocalizations.adc,
            appLocalizations.battery,
            appLocalizations.area,
            appLocalizations.step,
            appLocalizations.direction,
          ],
        );
        return true;
      } catch(e) {
        return false;
      }
    });
  }

  Future<bool> writeEntities({
    required Iterable<AmuletEntity> entities,
  }) {
    return _lock.synchronized(() async {
      for (var entity in entities) {
        try {
          await _file.writeAsString(
            data: [
              entity.id.toString(),
              entity.deviceId,
              entity.time.toIso8601String(),
              entity.accX.toString(),
              entity.accY.toString(),
              entity.accZ.toString(),
              entity.accTotal.toString(),
              // entity.gyroX.toString(),
              // entity.gyroY.toString(),
              // entity.gyroZ.toString(),
              // entity.gyroTotal.toString(),
              entity.magX.toString(),
              entity.magY.toString(),
              entity.magZ.toString(),
              entity.magTotal.toString(),
              entity.pitch.toString(),
              entity.roll.toString(),
              entity.yaw.toString(),
              // entity.gValue.toString(),
              entity.pressure.toString(),
              entity.temperature.toString(),
              entity.posture.name,
              entity.adc.toString(),
              entity.battery.toString(),
              entity.area.toString(),
              entity.step.toString(),
              entity.direction.toString(),
            ],
          );
        } catch(e) {
          return false;
        }
      }
      return true;
    });
  }
}
