import 'dart:typed_data';

import 'package:utl_mobile/utl_data_converter/utl_data_flags.dart';
import 'package:utl_mobile/utl_data_converter/utl_data_to_bytes.dart';

import '../utl_domain/utl_domain.dart';

const _CA_HEADER_LENGTH = 10;
const _DPV_HEADER_LENGTH = 16;

class UTL_Data_To_Bytes_Impl implements UTL_Data_To_Bytes {
  @override
  Uint8List convert(Iterable data) {
    BytesBuilder bytesBuilder = BytesBuilder();
    for(var d in data) {
      if(d is UTL_Data_CA_Command) {
        bytesBuilder.addByte(UTL_DATA_FLAG_CA_COMMAND);
        ByteData byteData = ByteData(_CA_HEADER_LENGTH);
        byteData.setInt16(0, d.E_dc, Endian.little);
        byteData.setUint16(2, d.t_interval, Endian.little);
        byteData.setUint16(4, d.t_run, Endian.little);
        bytesBuilder.add(byteData.buffer.asUint8List());
      }
      else if(d is UTL_Data_CV_Command) {
        bytesBuilder.addByte(UTL_DATA_FLAG_CV_COMMAND);
        ByteData byteData = ByteData(_DPV_HEADER_LENGTH);
        byteData.setInt16(0, d.E_begin, Endian.little);
        byteData.setInt16(2, d.E_vertex1, Endian.little);
        byteData.setInt16(4, d.E_vertex2, Endian.little);
        byteData.setUint16(6, d.E_step, Endian.little);
        byteData.setUint16(8, d.scan_rate, Endian.little);
        byteData.setUint8(10, d.number_of_scans);
        bytesBuilder.add(byteData.buffer.asUint8List());
      }
      else if(d is UTL_Data_DPV_Command) {
        bytesBuilder.addByte(UTL_DATA_FLAG_DPV_COMMAND);
        ByteData byteData = ByteData(_DPV_HEADER_LENGTH);
        byteData.setInt16(0, d.E_begin, Endian.little);
        byteData.setInt16(2, d.E_end, Endian.little);
        byteData.setInt16(4, d.E_step, Endian.little);
        byteData.setInt16(6, d.E_pulse, Endian.little);
        byteData.setUint16(8, d.t_pulse, Endian.little);
        byteData.setUint16(10, d.scan_rate, Endian.little);
        bytesBuilder.add(byteData.buffer.asUint8List());
      }
    }
    return bytesBuilder.takeBytes();
  }
}
