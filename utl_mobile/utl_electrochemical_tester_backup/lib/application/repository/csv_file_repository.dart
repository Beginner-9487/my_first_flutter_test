import 'package:flutter/cupertino.dart';
import 'package:flutter_file_utils/csv/simple_csv_file.dart';
import 'package:flutter_path_utils/path_provider_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utl_electrochemical_tester/application/dto/electrochemical_file_dto.dart';
import 'package:utl_electrochemical_tester/application/repository/file_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CsvFileRepository implements FileRepository {
  static get timeString {
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
  final BuildContext context;
  static late final String folder;
  static Future init() async {
    folder = ((await PathProviderUtil.getSystemDownloadDirectory()) ?? await getApplicationDocumentsDirectory()).absolute.path;
  }
  CsvFileRepository({
    required this.context,
  });

  AppLocalizations get appLocalizations => AppLocalizations.of(context)!;
  SimpleCsvFile? file;

  @override
  Future<bool> createFile() {
    String timeFileFormat = timeString;
    String electrochemicalFileName = "ElectrochemicalFile_$timeFileFormat";
    String electrochemicalFilePath = '$folder/$electrochemicalFileName.csv';
    return SimpleCsvFile(
      path: electrochemicalFilePath,
    )
    .clear(bom: true)
    .then((value) {
      file = value;
      file!.writeAsString(
        data: [
          "id",
          appLocalizations.name,
          "address",
          appLocalizations.time,
          appLocalizations.type,
          appLocalizations.temperature,
          "${appLocalizations.ca}: ${appLocalizations.eDc}",
          "${appLocalizations.ca}: ${appLocalizations.tInterval}",
          "${appLocalizations.ca}: ${appLocalizations.tRun}",
          "${appLocalizations.cv}: ${appLocalizations.eBegin}",
          "${appLocalizations.cv}: ${appLocalizations.eVertex1}",
          "${appLocalizations.cv}: ${appLocalizations.eVertex2}",
          "${appLocalizations.cv}: ${appLocalizations.eStep}",
          "${appLocalizations.cv}: ${appLocalizations.scanRate}",
          "${appLocalizations.cv}: ${appLocalizations.numberOfScans}",
          "${appLocalizations.dpv}: ${appLocalizations.eBegin}",
          "${appLocalizations.dpv}: ${appLocalizations.eEnd}",
          "${appLocalizations.dpv}: ${appLocalizations.eStep}",
          "${appLocalizations.dpv}: ${appLocalizations.ePulse}",
          "${appLocalizations.dpv}: ${appLocalizations.tPulse}",
          "${appLocalizations.dpv}: ${appLocalizations.scanRate}",
          appLocalizations.current,
        ],
      );
      return true;
    });
  }

  @override
  Future<bool> writeFile(Iterable<ElectrochemicalFileDto> dto) async {
    debugPrint("writeFile: $file");
    if(file == null) {
      return false;
    }
    debugPrint("dto: ${dto.length}");
    for(var d in dto) {
      await file!.writeAsString(
        data: [
          d.id,
          d.dataName,
          d.deviceId,
          d.createdTime,
          d.type,
          d.temperature,
          d.caEDc,
          d.caTInterval,
          d.caTRun,
          d.cvEBegin,
          d.cvEVertex1,
          d.cvEVertex2,
          d.cvEStep,
          d.cvScanRate,
          d.cvNumberOfScans,
          d.dpvEBegin,
          d.dpvEEnd,
          d.dpvEStep,
          d.dpvEPulse,
          d.dpvTPulse,
          d.dpvScanRate,
          d.dpvInversionOption,
          ...d.data.map((e) => e.toString()),
        ],
      );
    }
    return true;
  }
  
}