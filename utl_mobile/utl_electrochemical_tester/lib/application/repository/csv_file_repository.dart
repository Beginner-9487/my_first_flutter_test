import 'package:flutter/cupertino.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_system_path/system_path.dart';
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
  final RowCSVFileHandler rowCSVFileHandler;
  final SystemPath systemPath;
  CsvFileRepository({
    required this.context,
    required this.rowCSVFileHandler,
    required this.systemPath,
  });

  AppLocalizations get appLocalizations => context.appLocalizations!;
  String get folder => systemPath.system_download_path_absolute;

  RowCSVFile? file;
  @override
  Future<bool> createFile()  {
    String timeFileFormat = timeString;
    String electrochemicalFileName = "ElectrochemicalFile_$timeFileFormat";
    String electrochemicalFilePath = '$folder/$electrochemicalFileName.csv';
    return rowCSVFileHandler.createEmptyFile(
      electrochemicalFilePath,
      bom: true,
    ).then((value) {
      file = value;
      file!.write([
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
      ]);
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
      await file!.write([
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
      ]);
    }
    return true;
  }
  
}