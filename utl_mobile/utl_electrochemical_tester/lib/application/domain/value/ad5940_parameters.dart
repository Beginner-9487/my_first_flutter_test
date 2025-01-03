import 'dart:typed_data';

enum AD5940ParametersHsTiaRTia {
  HSTIARTIA_200,
  HSTIARTIA_1K,
  HSTIARTIA_5K,
  HSTIARTIA_10K,
  HSTIARTIA_20K,
  HSTIARTIA_40K,
  HSTIARTIA_80K,
  HSTIARTIA_160K,
  HSTIARTIA_OPEN,
}

class AD5940Parameters {
  AD5940ParametersHsTiaRTia hsTiaRTia;
  AD5940Parameters({
    required this.hsTiaRTia,
  });
  Uint8List get data {
    final byteData = ByteData(4);
    byteData.setUint32(0, hsTiaRTia.index, Endian.little);
    return byteData.buffer.asUint8List();
  }
}
