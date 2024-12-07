import 'dart:async';

import 'package:flutter_bt/bt.dart';
import 'package:flutter_file_handler/row_csv_file.dart';
import 'package:flutter_system_path/system_path.dart';
import 'package:utl_hands/application/domain/hand_repository.dart';
import 'package:utl_hands/application/infrastructure/save_file_handler.dart';

class SaveFileHandlerRow extends SaveFileHandler<HandRow> {
  SaveFileHandlerRow._(
      this.systemPath,
      this.provider,
  ) {
    _setTimer();
  }
  SystemPath systemPath;
  static SaveFileHandlerRow? _instance;
  static SaveFileHandlerRow getInstance(
      SystemPath systemPath,
      BT_Provider provider,
  ) {
    _instance ??= SaveFileHandlerRow._(
        systemPath,
        provider,
    );
    return _instance!;
  }
  BT_Provider provider;

  _setTimer() {
    Timer(const Duration(milliseconds: 1), () async {
      await saveFile();
      _setTimer();
    });
  }

  List<String> get _HEADER => [
    // R.str.id,
    // R.str.time,
    "ID",
    "Time",
    "X0",
    "Y0",
    "Z0",
    "X1",
    "Y1",
    "Z1",
  ];

  @override
  initFile() async {
    await super.initFile();
    await fileLeft.write(_HEADER);
    await fileRight.write(_HEADER);
  }

  @override
  addDataToFile(HandRow data) async {
    if(!isFileBeenCreated) {
      return;
    }
    if(data.isRight) {
      buffer.add((fileRight, data));
    } else {
      buffer.add((fileLeft, data));
    }
  }

  List<String> _footRowToFileFormat(HandRow row) {
    return [
      row.id.toString(),
      timeStampFormatStringForContent,
      row.x0.toString(),
      row.y0.toString(),
      row.z0.toString(),
      row.x1.toString(),
      row.y1.toString(),
      row.z1.toString(),
    ];
  }

  List<(RowCSVFile, HandRow)> buffer = [];
  /// Make sure that both footLeft and footRight files have the same length.
  saveFile() async {
    if(!isFileBeenCreated) {
      return;
    }
    int maxLength = buffer.length;
    int finalLength = 0;
    (RowCSVFile, HandRow)? buffer1;
    for(int i=0; i<maxLength; i++) {
      // if(i>=buffer.length) {
      //   break;
      // }
      if(provider.allDevices.where((element) => element.isConnected).length == 1) {
        await buffer[i].$1.write(_footRowToFileFormat(buffer[i].$2));
        continue;
      }
      if(buffer1 == null) {
        buffer1 = buffer[i];
        // debugPrint("buffer1: ${buffer1.$2.bodyPart}");
      } else if(buffer1.$1 != buffer[i].$1) {
        finalLength = i;
        await buffer1.$1.write(_footRowToFileFormat(buffer1.$2));
        await buffer[i].$1.write(_footRowToFileFormat(buffer[i].$2));
        // debugPrint("buffer[i]: $i, ${buffer[i].$2.bodyPart}");
        buffer1 = null;
      }
    }
    buffer.removeRange(0, finalLength);
  }
}