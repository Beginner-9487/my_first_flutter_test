import 'package:flutter/cupertino.dart';
import 'package:flutter_file_handler/application/simple_excel_file.dart';
import 'package:flutter_file_handler/application/simple_excel_file_impl.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/resources/global_variables.dart';
import 'package:flutter_util/path.dart';

class MackayIRBFileHandler {
  static DateTime get _initTime {
    return GlobalVariables.instance.initTimeStamp;
  }
  static get _initTimeStampFormatString {
    return "${_initTime.year}-${_initTime.month}-${_initTime.day}_${_initTime.hour}-${_initTime.minute}-${_initTime.second}";
  }
  static var factory = SimpleExcelFileFactoryImpl();
  static Future<String> get savedFolder async => await Path.systemDownloadPath;

  static saveMeasurementFile(MackayIRBEntity entity) async {
    String filePath = '${await savedFolder}/${entity.name}.xlsx';
    String sheetName = 'Sheet1';
    var file = await factory.createEmptyFile(filePath);
    var sheet = file.createNewSheet(sheetName);

    List<List<String>> header = [
      ["Name", entity.name],
      ["Time", "${DateTime.now().millisecondsSinceEpoch}"],
      ["Type", "${entity.type}"],
      ["Number", "Time", "Voltage", "Current"],
    ];

    List<List<String>> data = header;
    int index = 0;
    for(MackayIRBRow row in entity.rows) {
      while(index != row.index) {
        data.add([]);
        index++;
      }
      data.add([
        "${row.index}",
        "",
        "${row.voltage}",
        "${row.current}",
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

  static save5sFile(MackayIRBEntity entity) async {
    String filePath = '${await Path.systemDownloadPath}/${_initTimeStampFormatString}_5s.xlsx';
    String sheetName = 'Sheet1';
    late SimpleExcelFile file;
    late SimpleExcelSheet sheet;
    try {
      file = await factory.readFile(filePath);
    } catch(e) {
      file = await factory.createEmptyFile(filePath);
    }
    try {
      sheet = file.getSheetByName(sheetName);
    } catch(e) {
      sheet = file.createNewSheet(sheetName);
    }

    sheet.write(sheet.rowsLength, 0, "${entity.rows.skip(50).first.voltage}");
    sheet.write(sheet.rowsLength, 1, "${entity.rows.skip(50).first.current}");

    if(await file.save()) {
      debugPrint('Mackay IRB 5s file saved successfully!');
    } else {
      debugPrint('Mackay IRB 5s file saved unsuccessfully!');
    }
  }
}