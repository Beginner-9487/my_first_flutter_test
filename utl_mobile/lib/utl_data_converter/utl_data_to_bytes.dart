import 'dart:typed_data';

abstract class UTL_Data_To_Bytes {
  Uint8List convert(Iterable<dynamic> data);
}
