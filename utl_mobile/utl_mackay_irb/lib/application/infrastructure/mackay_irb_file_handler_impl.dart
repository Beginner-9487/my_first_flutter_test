import 'package:flutter/cupertino.dart';
import 'package:flutter_file_handler/application/simple_excel_file.dart';
import 'package:flutter_file_handler/application/simple_excel_file_impl.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_type_impl.dart';
import 'package:flutter_util/path.dart';
import 'package:utl_mackay_irb/application/infrastructure/mackay_irb_file_handler.dart';

class MackayIRBFileHandlerImpl extends MackayIRBFileHandler {
  static MackayIRBFileHandlerImpl? _instance;
  MackayIRBFileHandlerImpl._();
  static MackayIRBFileHandlerImpl getInstance() {
    _instance ??= MackayIRBFileHandlerImpl._();
    return _instance!;
  }

  var factory = SimpleExcelFileFactoryImpl();
  Future<String> get savedFolder async => await Path.systemDownloadPath;

  @override
  saveMeasurementFile(MackayIRBEntity entity) async {
    String filePath = '${await savedFolder}/${entity.data_name}-${entity.created_time_format_for_filename}-${entity.type_name}.xlsx';
    String sheetName = 'Sheet1';
    var file = await factory.createEmptyFile(filePath);
    var sheet = file.createNewSheet(sheetName);

    List<List<String>> header = [
      [R.str.name, entity.data_name],
      [R.str.device, entity.device_name],
      [R.str.type, entity.type.name],
      ["${R.str.time} (Created)", entity.created_time_format],
      ["${R.str.time} (Finished)", entity.finished_time_format],
      [R.str.number, "${entity.number_of_data}"],
      [R.str.temperature, "${entity.temperature}"],
      [R.str.index, R.str.time, R.str.voltage, R.str.current],
    ];

    List<List<String>> data = header;
    int index = 0;
    for(MackayIRBRow row in entity.rows) {
      while(index != row.index) {
        data.add([]);
        index++;
      }
      data.add([
        row.index.toString(),
        row.created_time_related_to_entity_format,
        row.voltage.toString(),
        row.current.toString(),
      ]);
      index++;
    }

    sheet.writeRegion(data);
    if(await file.save()) {
      debugPrint('Mackay IRB Measurement file saved successfully!');
    } else {
      debugPrint('Mackay IRB Measurement file saved unsuccessfully!');
    }
  }

  final List<_FileBuffer5s> _file_buffer_5s_array = [];
  @override
  save5sFile(MackayIRBEntity entity) async {
    _FileBuffer5s? buffer = _file_buffer_5s_array
        .where((element) => element.name == entity.data_name)
        .firstOrNull;
    if(buffer == null) {
        buffer = _FileBuffer5s();
        await buffer.create_new_file(entity);
        _file_buffer_5s_array.add(buffer);
    }
    await buffer.write(entity);
  }
}

class _FileBuffer5s {
  SimpleExcelFileFactoryImpl get factory => MackayIRBFileHandlerImpl.getInstance().factory;
  late SimpleExcelFile file;
  late SimpleExcelSheet sheet;
  late String name;
  MackayIRBEntity? get _base_entity => _cortisol_entity;
  MackayIRBEntity? _cortisol_entity;
  MackayIRBEntity? _lactate_entity;
  _FileBuffer5s();
  _add(MackayIRBEntity entity) {
    switch(entity.type) {
      case CortisolMackayIRBType():
        _cortisol_entity = entity;
        break;
      case LactateMackayIRBType():
        _lactate_entity = entity;
        break;
      default:
        break;
    }
  }
  _clear_entities() {
    _cortisol_entity = null;
    _lactate_entity = null;
  }
  create_new_file(MackayIRBEntity first_entity) async {
    name = first_entity.data_name;
    file = await _get_file_5s(first_entity);
    sheet = await _get_sheet_5s(first_entity, file);
  }
  Future<SimpleExcelFile> _get_file_5s(MackayIRBEntity entity) async {
    String filePath = '${await Path.systemDownloadPath}/${entity.data_name}_${entity.created_time_format_for_filename}_All_5s.xlsx';
    late SimpleExcelFile file;
    try {
      file = await factory.readFile(filePath);
    } catch(e) {
      file = await factory.createEmptyFile(filePath);
    }
    return file;
  }
  Future<SimpleExcelSheet> _get_sheet_5s(MackayIRBEntity first_entity, SimpleExcelFile file) async {
    String sheetName = 'Sheet1';
    late SimpleExcelSheet sheet;
    try {
      sheet = file.getSheetByName(sheetName);
    } catch(e) {
      sheet = file.createNewSheet(sheetName);
    }

    if(sheet.rowsLength == 0) {
      List<List<String>> header = [
        [
          R.str.name,
          first_entity.data_name,
        ],
        [
          "${R.str.time} (Created)",
          first_entity.created_time_format,
        ],
        [
          R.str.name,
          "${R.str.time} (First Created)",
          R.str.temperature,
          "${R.str.current}: ${R.str.cortisol}",
          "${R.str.current}: ${R.str.lactate}",
        ],
      ];
      sheet.writeRegion(header);
    }
    return sheet;
  }
  Future write(MackayIRBEntity entity) async {
    _add(entity);

    if(
      _base_entity == null
          || _cortisol_entity == null
          || _lactate_entity == null
    ) {
      return;
    }

    int _index_row = sheet.rowsLength;
    int _index_column = 0;
    sheet.write(_index_row, _index_column++, _base_entity!.data_name);
    sheet.write(_index_row, _index_column++, _base_entity!.created_time_format);
    sheet.write(_index_row, _index_column++, _base_entity!.temperature.toString());
    sheet.write(_index_row, _index_column++, (_cortisol_entity != null)
        ? _cortisol_entity!
        .get_row_by_time(5)
        .current.toString()
        : "");
    sheet.write(_index_row, _index_column++, (_lactate_entity != null)
        ? _lactate_entity!
        .get_row_by_time(5)
        .current.toString()
        : "");

    _clear_entities();

    if(await file.save()) {
      debugPrint('Mackay IRB 5s file saved successfully!');
    } else {
      debugPrint('Mackay IRB 5s file saved unsuccessfully!');
    }
  }
}