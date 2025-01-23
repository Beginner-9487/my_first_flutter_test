enum Ad5940ParametersHsTiaRTia {
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

class Ad5940Parameters {
  Ad5940ParametersHsTiaRTia hsTiaRTia;
  Ad5940Parameters({
    required this.hsTiaRTia,
  });
  @override
  String toString() {
    return "Ad5940Parameters: "
        "\n\thsTiaRTia: ${hsTiaRTia.name}"
    ;
  }
}
