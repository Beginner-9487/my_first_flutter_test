import 'package:flutter/cupertino.dart';
import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:utl_electrochemical_tester/application/data/electrochemical_parameters.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
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
  static late final RowCSVFileHandler _rowCSVFileHandler;
  static late final SystemPath _systemPath;
  static void init({
    required RowCSVFileHandler rowCSVFileHandler,
    required SystemPath systemPath,
  }) {
    _rowCSVFileHandler = rowCSVFileHandler;
    _systemPath = systemPath;
  }
  CsvFileRepository({
    required BuildContext context,
  }) : _context = context;

  final BuildContext _context;
  AppLocalizations get _str => _context.appLocalizations!;
  String get _savedFolder => _systemPath.system_download_path_absolute;

  RowCSVFile? _file;
  @override
  Future<bool> createFile() async {
    String timeFileFormat = timeString;
    String electrochemicalFileName = "ElectrochemicalFile_$timeFileFormat";
    String electrochemicalFilePath = '$_savedFolder/$electrochemicalFileName.csv';
    _rowCSVFileHandler.createEmptyFile(
      electrochemicalFilePath,
      bom: true,
    ).then((value) {
      _file = value;
      _file!.write([
        "id",
        _str.name,
        "address",
        _str.time,
        _str.type,
        _str.temperature,
        "${_str.ca}: ${_str.e_dc}",
        "${_str.ca}: ${_str.t_interval}",
        "${_str.ca}: ${_str.t_run}",
        "${_str.cv}: ${_str.e_begin}",
        "${_str.cv}: ${_str.e_vertex1}",
        "${_str.cv}: ${_str.e_vertex2}",
        "${_str.cv}: ${_str.e_step}",
        "${_str.cv}: ${_str.scan_rate}",
        "${_str.cv}: ${_str.number_of_scans}",
        "${_str.dpv}: ${_str.e_begin}",
        "${_str.dpv}: ${_str.e_end}",
        "${_str.dpv}: ${_str.e_step}",
        "${_str.dpv}: ${_str.e_pulse}",
        "${_str.dpv}: ${_str.t_pulse}",
        "${_str.dpv}: ${_str.scan_rate}",
        _str.current,
      ]);
    });
    return true;
  }

  @override
  Future<bool> writeFile(Iterable<ElectrochemicalDataEntity> entities) async {
    if(_file == null) {
      return false;
    }
    for(var entity in entities) {
      await _file!.write([
        entity.id.toString(),
        entity.dataName,
        entity.deviceId,
        entity.createdTime.toString(),
        entity.type.toString(),
        entity.temperature.toString(),
        entity.parameters is! CaElectrochemicalParameters ? "" : (entity.parameters as CaElectrochemicalParameters).eDc.toString(),
        entity.parameters is! CaElectrochemicalParameters ? "" : (entity.parameters as CaElectrochemicalParameters).tInterval.toString(),
        entity.parameters is! CaElectrochemicalParameters ? "" : (entity.parameters as CaElectrochemicalParameters).tRun.toString(),
        entity.parameters is! CvElectrochemicalParameters ? "" : (entity.parameters as CvElectrochemicalParameters).eBegin.toString(),
        entity.parameters is! CvElectrochemicalParameters ? "" : (entity.parameters as CvElectrochemicalParameters).eVertex1.toString(),
        entity.parameters is! CvElectrochemicalParameters ? "" : (entity.parameters as CvElectrochemicalParameters).eVertex2.toString(),
        entity.parameters is! CvElectrochemicalParameters ? "" : (entity.parameters as CvElectrochemicalParameters).eStep.toString(),
        entity.parameters is! CvElectrochemicalParameters ? "" : (entity.parameters as CvElectrochemicalParameters).scanRate.toString(),
        entity.parameters is! CvElectrochemicalParameters ? "" : (entity.parameters as CvElectrochemicalParameters).numberOfScans.toString(),
        entity.parameters is! DpvElectrochemicalParameters ? "" : (entity.parameters as DpvElectrochemicalParameters).eBegin.toString(),
        entity.parameters is! DpvElectrochemicalParameters ? "" : (entity.parameters as DpvElectrochemicalParameters).eEnd.toString(),
        entity.parameters is! DpvElectrochemicalParameters ? "" : (entity.parameters as DpvElectrochemicalParameters).eStep.toString(),
        entity.parameters is! DpvElectrochemicalParameters ? "" : (entity.parameters as DpvElectrochemicalParameters).ePulse.toString(),
        entity.parameters is! DpvElectrochemicalParameters ? "" : (entity.parameters as DpvElectrochemicalParameters).tPulse.toString(),
        entity.parameters is! DpvElectrochemicalParameters ? "" : (entity.parameters as DpvElectrochemicalParameters).scanRate.toString(),
        ...entity.data.map((e) => e.current.toString()),
      ]);
    }
    return true;
  }
  
}