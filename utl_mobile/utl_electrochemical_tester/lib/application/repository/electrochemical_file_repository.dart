import 'package:flutter_context_resource/context_resource.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:utl_electrochemical_tester/application/use_case/electrochemical_data.dart';

abstract class Electrochemical_File_Repository {
  Future<bool> saveElectrochemicalFile(Electrochemical_File_Data data);
  Future<bool> saveYiQinFile(Electrochemical_File_Data data);
}

class Electrochemical_File_Repository_Impl implements Electrochemical_File_Repository {
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
  Electrochemical_File_Repository_Impl({
    required this.contextResource,
    required this.rowCSVFileHandler,
    required this.systemPath,
  }) {
    String timeFileFormat = timeString;
    String electrochemicalFileName = "ElectrochemicalFile_$timeFileFormat";
    String electrochemicalFilePath = '$savedFolder/$electrochemicalFileName.csv';
    rowCSVFileHandler.createEmptyFile(
      electrochemicalFilePath,
      bom: true,
    ).then((value) {
      electrochemicalFile = value;
      electrochemicalFile!.write([
        "id",
        contextResource.str.name,
        "address",
        contextResource.str.time,
        contextResource.str.type,
        contextResource.str.temperature,
        "${contextResource.str.ca}: ${contextResource.str.e_dc}",
        "${contextResource.str.ca}: ${contextResource.str.t_interval}",
        "${contextResource.str.ca}: ${contextResource.str.t_run}",
        "${contextResource.str.cv}: ${contextResource.str.e_begin}",
        "${contextResource.str.cv}: ${contextResource.str.e_vertex1}",
        "${contextResource.str.cv}: ${contextResource.str.e_vertex2}",
        "${contextResource.str.cv}: ${contextResource.str.e_step}",
        "${contextResource.str.cv}: ${contextResource.str.scan_rate}",
        "${contextResource.str.cv}: ${contextResource.str.number_of_scans}",
        "${contextResource.str.dpv}: ${contextResource.str.e_begin}",
        "${contextResource.str.dpv}: ${contextResource.str.e_end}",
        "${contextResource.str.dpv}: ${contextResource.str.e_step}",
        "${contextResource.str.dpv}: ${contextResource.str.e_pulse}",
        "${contextResource.str.dpv}: ${contextResource.str.t_pulse}",
        "${contextResource.str.dpv}: ${contextResource.str.scan_rate}",
        contextResource.str.current,
      ]);
    });
    String YiQinFileName = "YiQin_All_5s_$timeFileFormat";
    String YiQinFilePath = '$savedFolder/$YiQinFileName.csv';
    rowCSVFileHandler.createEmptyFile(
      YiQinFilePath,
      bom: true,
    ).then((value) {
      YiQinFile = value;
      YiQinFile!.write([
        contextResource.str.name,
        contextResource.str.time,
        contextResource.str.type,
        contextResource.str.temperature,
        contextResource.str.current,
      ]);
    });
  }

  ContextResource contextResource;
  RowCSVFileHandler rowCSVFileHandler;
  SystemPath systemPath;

  String get savedFolder => systemPath.system_download_path_absolute;
  RowCSVFile? electrochemicalFile;
  RowCSVFile? YiQinFile;

  @override
  Future<bool> saveElectrochemicalFile(Electrochemical_File_Data data) async {
    if(electrochemicalFile == null) {
      return false;
    }
    return electrochemicalFile!.write([
      data.id.toString(),
      data.data_name,
      data.device_address,
      data.created_time,
      data.typeString,
      data.temperature.toString(),
      (data.CA_header == null) ? "" : data.CA_header!.E_dc.toString(),
      (data.CA_header == null) ? "" : data.CA_header!.t_interval.toString(),
      (data.CA_header == null) ? "" : data.CA_header!.t_run.toString(),
      (data.CV_header == null) ? "" : data.CV_header!.E_begin.toString(),
      (data.CV_header == null) ? "" : data.CV_header!.E_vertex1.toString(),
      (data.CV_header == null) ? "" : data.CV_header!.E_vertex2.toString(),
      (data.CV_header == null) ? "" : data.CV_header!.E_step.toString(),
      (data.CV_header == null) ? "" : data.CV_header!.scan_rate.toString(),
      (data.CV_header == null) ? "" : data.CV_header!.number_of_scans.toString(),
      (data.DPV_header == null) ? "" : data.DPV_header!.E_begin.toString(),
      (data.DPV_header == null) ? "" : data.DPV_header!.E_end.toString(),
      (data.DPV_header == null) ? "" : data.DPV_header!.E_step.toString(),
      (data.DPV_header == null) ? "" : data.DPV_header!.E_pulse.toString(),
      (data.DPV_header == null) ? "" : data.DPV_header!.t_pulse.toString(),
      (data.DPV_header == null) ? "" : data.DPV_header!.scan_rate.toString(),
      ...data.points.map((e) => e.current.toString()),
    ]).then((value) => true);
  }

  @override
  Future<bool> saveYiQinFile(Electrochemical_File_Data data) async {
    if(YiQinFile == null) {
      return false;
    }
    Electrochemical_File_Data_Point? targetPoint = data.points.where((element) => Duration(microseconds: element.time_since_created).inSeconds == 5).firstOrNull;
    if(targetPoint == null) {
      return false;
    }
    if(data.CA_header == null) {
      return false;
    }
    return YiQinFile!.write([
      data.data_name,
      data.created_time,
      (data.CA_header!.E_dc == 0.35) ? contextResource.str.lactate : contextResource.str.cortisol,
      data.temperature.toString(),
      targetPoint.current.toString(),
    ]).then((value) => true);
  }
  
}