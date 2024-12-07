import 'dart:typed_data';

import 'package:utl_mobile/utl_data_converter/utl_bytes_to_data.dart';
import 'package:utl_mobile/utl_data_converter/utl_data_flags.dart';
import 'package:utl_mobile/utl_domain/utl_domain.dart';

const _CA_HEADER_LENGTH = 10;
const _CV_HEADER_LENGTH = 16;
const _DPV_HEADER_LENGTH = 16;

class UTL_Bytes_to_Data_Impl implements UTL_Bytes_to_Data {
  @override
  Iterable<dynamic> convert(Uint8List bytes) {
    List<dynamic> data = [];
    ByteData byteData = ByteData.sublistView(bytes);
    int byteOffset = 0;
    while(byteOffset < byteData.lengthInBytes) {
      int flag = byteData.getUint8(byteOffset);
      byteOffset++;
      switch(flag) {

        case UTL_DATA_FLAG_CURRENTS:
          if(byteOffset + 2 > byteData.lengthInBytes) {
            break;
          }
          int currentsLength = byteData.getUint16(byteOffset + 0, Endian.little);
          byteOffset += 2;
          if(byteOffset + currentsLength * 4 > byteData.lengthInBytes) {
            break;
          }
          data.add(UTL_Data_Currents_Impl(
              currents: List.generate(
                  currentsLength,
                  (int index) => byteData.getInt32(byteOffset + (index * 4), Endian.little),
              ),
          ));
          byteOffset += currentsLength * 4;

        case UTL_DATA_FLAG_CA_HEADER:
          if(byteOffset + _CA_HEADER_LENGTH > byteData.lengthInBytes) {
            break;
          }
          data.add(UTL_Data_CA_Header_Impl(
            temperature: byteData.getInt32(byteOffset + 0, Endian.little),
            E_dc: byteData.getInt16(byteOffset + 4, Endian.little),
            t_interval: byteData.getUint16(byteOffset + 6, Endian.little),
            t_run: byteData.getUint16(byteOffset + 8, Endian.little),
          ));
          byteOffset += _CA_HEADER_LENGTH;

        case UTL_DATA_FLAG_CV_HEADER:
          if(byteOffset + _CV_HEADER_LENGTH > byteData.lengthInBytes) {
            break;
          }
          data.add(UTL_Data_CV_Header_Impl(
            temperature: byteData.getInt32(byteOffset + 0, Endian.little),
            E_begin: byteData.getInt16(byteOffset + 4, Endian.little),
            E_vertex1: byteData.getInt16(byteOffset + 6, Endian.little),
            E_vertex2: byteData.getInt16(byteOffset + 8, Endian.little),
            E_step: byteData.getUint16(byteOffset + 10, Endian.little),
            scan_rate: byteData.getUint16(byteOffset + 12, Endian.little),
            number_of_scans: byteData.getUint8(byteOffset + 14),
          ));
          byteOffset += _CA_HEADER_LENGTH;

        case UTL_DATA_FLAG_DPV_HEADER:
          if(byteOffset + _DPV_HEADER_LENGTH > byteData.lengthInBytes) {
            break;
          }
          data.add(UTL_Data_DPV_Header_Impl(
              temperature: byteData.getInt32(byteOffset + 0, Endian.little),
              E_begin: byteData.getInt16(byteOffset + 4, Endian.little),
              E_end: byteData.getInt16(byteOffset + 6, Endian.little),
              E_step: byteData.getInt16(byteOffset + 8, Endian.little),
              E_pulse: byteData.getInt16(byteOffset + 10, Endian.little),
              t_pulse: byteData.getUint16(byteOffset + 12, Endian.little),
              scan_rate: byteData.getUint16(byteOffset + 14, Endian.little),
          ));
          byteOffset += _DPV_HEADER_LENGTH;

        default:
          return data;

      }
    }
    return data;
  }
}
