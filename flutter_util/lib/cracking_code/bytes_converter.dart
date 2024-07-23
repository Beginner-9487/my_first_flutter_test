import 'dart:math';
import 'dart:typed_data';

class BytesConverter {
  BytesConverter._();

  static int byteArrayToSignedInt(List<int> bytes) {
    int value = byteArrayToUnsignedInt(bytes);
    // If the most significant bit of the final byte is set, the value is negative.
    if ((bytes[0] & 0x80) != 0) {
      // Extend the sign bit to fill the entire integer value.
      value = -((pow(256, bytes.length)).toInt() - value);
    }
    return value;
  }

  static int byteArrayToUnsignedInt(List<int> bytes) {
    int value = 0;
    for (int i = 0; i < bytes.length; i++) {
      value = (value << 8) | bytes[i];
    }
    return value;
  }

  static double byteArrayToFloat(List<int> bytes) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getFloat32(0, Endian.little); // Assuming little endian
  }
  static double byteArrayToDouble(List<int> bytes) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getFloat64(0, Endian.little); // Assuming little endian
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