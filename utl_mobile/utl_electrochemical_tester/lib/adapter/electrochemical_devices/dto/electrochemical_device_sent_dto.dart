import 'package:utl_electrochemical_tester/adapter/electrochemical_devices/dto/ad5940_parameters.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

abstract class ElectrochemicalDeviceSentDto {
  Ad5940Parameters get ad5940Parameters;
  String get dataName;
  @override
  String toString() {
    return "ElectrochemicalDeviceSentCaDto: "
        "\n\tad5940Parameters: $ad5940Parameters"
        "\n\tdataName: $dataName"
    ;
  }
}

class CaElectrochemicalDeviceSentDto implements ElectrochemicalDeviceSentDto {
  @override
  final Ad5940Parameters ad5940Parameters;
  @override
  final String dataName;
  final CaElectrochemicalParameters electrochemicalParameters;
  const CaElectrochemicalDeviceSentDto({
    required this.ad5940Parameters,
    required this.dataName,
    required this.electrochemicalParameters,
  });
  @override
  String toString() {
    return "CaElectrochemicalDeviceSentDto: "
        "\n\tad5940Parameters: $ad5940Parameters"
        "\n\tdataName: $dataName"
        "\n\telectrochemicalParameters: $electrochemicalParameters"
    ;
  }
}

class CvElectrochemicalDeviceSentDto implements ElectrochemicalDeviceSentDto {
  @override
  final Ad5940Parameters ad5940Parameters;
  @override
  final String dataName;
  final CvElectrochemicalParameters electrochemicalParameters;
  const CvElectrochemicalDeviceSentDto({
    required this.ad5940Parameters,
    required this.dataName,
    required this.electrochemicalParameters,
  });
  @override
  String toString() {
    return "CvElectrochemicalDeviceSentDto: "
        "\n\tad5940Parameters: $ad5940Parameters"
        "\n\tdataName: $dataName"
        "\n\telectrochemicalParameters: $electrochemicalParameters"
    ;
  }
}

class DpvElectrochemicalDeviceSentDto implements ElectrochemicalDeviceSentDto {
  @override
  final Ad5940Parameters ad5940Parameters;
  @override
  final String dataName;
  final DpvElectrochemicalParameters electrochemicalParameters;
  const DpvElectrochemicalDeviceSentDto({
    required this.ad5940Parameters,
    required this.dataName,
    required this.electrochemicalParameters,
  });
  @override
  String toString() {
    return "DpvElectrochemicalDeviceSentDto: "
        "\n\tad5940Parameters: $ad5940Parameters"
        "\n\tdataName: $dataName"
        "\n\telectrochemicalParameters: $electrochemicalParameters"
    ;
  }
}
