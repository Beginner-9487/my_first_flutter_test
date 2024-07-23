import 'package:pytorch_mobile/enums/dtype.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';

class AIModel {
  static const String _CONVERT_FOOT_MAGNETS_TO_PRESSURE_MODEL_PATH = "assets/models/foot_magnets_convert_into_pressure.pt";
  static late Model _customModel;
  static bool _isInitiated = false;
  static init() async {
    try {
      _customModel = await PyTorchMobile
          .loadModel(_CONVERT_FOOT_MAGNETS_TO_PRESSURE_MODEL_PATH);
      _isInitiated = true;
    } catch(e) {
      throw Exception("Error: AIModel.init: ${e.toString()}");
    }
  }
  static Future<List<double>> convertFootMagnetsToPressure(double magX, double magY, double magZ) async {
    if(!_isInitiated) {
      throw Exception("The model has not been initialized yet.");
    }
    List<double> prediction = (await _customModel
        .getPrediction(
          [magX, magY, magZ],
          [1, 3],
          DType.float32,
        ))!
        .map((e) => e as double)
        .toList();
    return prediction;
  }
}