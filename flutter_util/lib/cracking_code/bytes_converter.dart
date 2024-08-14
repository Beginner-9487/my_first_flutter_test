import 'dart:math';
import 'dart:typed_data';

class BytesConverter {
  BytesConverter._();

  static int byteArrayToInt16(List<int> bytes, {bool little = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getInt16(0, (little) ? Endian.little : Endian.big);
  }
  
  static int byteArrayToInt32(List<int> bytes, {bool little = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getInt32(0, (little) ? Endian.little : Endian.big);
  }
  
  static int byteArrayToUint8(List<int> bytes) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getInt8(0);
  }

  static int byteArrayToUint16(List<int> bytes, {bool little = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getInt16(0, (little) ? Endian.little : Endian.big);
  }

  static double byteArrayToFloat(List<int> bytes, {bool little = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getFloat32(0, (little) ? Endian.little : Endian.big);
  }
  static double byteArrayToDouble(List<int> bytes, {bool little = true}) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getFloat64(0, (little) ? Endian.little : Endian.big);
  }

  static List<int> hexStringToByteArray(String s) {
    int len = s.length;
    List<int> data = [];
    for (int i = 0; i < len; i += 2) {
      data.add(int.parse(s.substring(i, i + 2), radix: 16));
    }
    return data;
  }
}