import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/resources/global_variables.dart';

import 'package:utl_mobile/utils/data_color_generator.dart';

class FootMapUseCase {
  final GlobalVariables _globalVariables;
  FootRepository get _footRepository => _globalVariables.footRepository;

  static const double PRESSURE_MAX = -4;
  static const double PRESSURE_MIN = -30;
  static const int PRESSURE_COLOR_STEP = 6;

  static const double SHEAR_FORCE_MAX = 15;
  static const double SHEAR_FORCE_MIN = 5;

  static const double TEMPERATURE_MAX = 40;
  static const double TEMPERATURE_MIN = 20;
  static const int TEMPERATURE_COLOR_STEP = 8;

  // static getPressureColor(double pressure) {
  //   // debugPrint("pressure: $pressure");
  //   return DataColorGenerator.rainbow(
  //     alpha: 1,
  //     dataIndex: PRESSURE_COLOR_STEP - ((max(min(pressure, PRESSURE_MAX) - PRESSURE_MIN, 0) / (PRESSURE_MAX - PRESSURE_MIN)) * PRESSURE_COLOR_STEP).floor(),
  //     dataSize: PRESSURE_COLOR_STEP,
  //   );
  // }
  //
  // static getShearForceColor(double shearForce) {
  //   // debugPrint("shearForce: $shearForce");
  //   return DataColorGenerator.grayscale(
  //     alpha: 1,
  //     dataIndex: 0,
  //     dataSize: 1,
  //   );
  // }
  //
  // static getShearForceRatio(double shearForce) {
  //   return (max(min(shearForce, SHEAR_FORCE_MAX) - SHEAR_FORCE_MIN, 0) / (SHEAR_FORCE_MAX - SHEAR_FORCE_MIN));
  // }

  static getTemperature(double temperature) {
    // debugPrint("temperature: $temperature");
    return DataColorGenerator.rainbow(
      alpha: 1,
      dataIndex: TEMPERATURE_COLOR_STEP - ((max(min(temperature, TEMPERATURE_MAX) - TEMPERATURE_MIN, 0) / (TEMPERATURE_MAX - TEMPERATURE_MIN)) * TEMPERATURE_COLOR_STEP).floor(),
      dataSize: TEMPERATURE_COLOR_STEP,
    );
  }

  static const double _MAG_Z_MAX = 56000;
  static const double _MAG_Z_MIN = 42000;
  static getMagZColor(double magZ) {
    return DataColorGenerator.rainbow(
      alpha: 1,
      dataIndex: PRESSURE_COLOR_STEP - ((max(min(magZ, _MAG_Z_MAX) - _MAG_Z_MIN, 0) / (_MAG_Z_MAX - _MAG_Z_MIN)) * PRESSURE_COLOR_STEP).floor(),
      dataSize: PRESSURE_COLOR_STEP,
    );
  }
  static getMagXYColor(double magX, double magY) {
      return DataColorGenerator.grayscale(
        alpha: 1,
        dataIndex: 0,
        dataSize: 1,
      );
  }
  static const double _MAG_XY_MAX = 25000;
  static const double _MAG_XY_MIN = 5000;
  static const double _MAG_XY_CENTER = 32767;
  static getMagXYRatio(double magX, double magY) {
    double length = sqrt(pow(magX - _MAG_XY_CENTER, 2) + pow(magY - _MAG_XY_CENTER, 2));
    if(length < _MAG_XY_MIN) {
      return 0.0;
    }
    if(length > _MAG_XY_MAX) {
      return 1.0;
    }
    return (length - _MAG_XY_MIN) / (_MAG_XY_MAX - _MAG_XY_MIN);
  }
  static getMagXYDirectionRadians(double magX, double magY) {
    return atan2(magX - _MAG_XY_CENTER, magY - _MAG_XY_CENTER);
  }

  Iterable<FootRow> targetRow(FootEntity entity) {
    return entity.rows;
  }

  FootMapUseCase(this._globalVariables);
  List<FootMapSensorUnitDto> get sensorData {
    return _footRepository.entities
      .where((element) => targetRow(element).isNotEmpty)
      .map((element) => targetRow(element).last)
      .map((e) => e.sensorsData
        .map((e) => FootMapSensorUnitDto(
          position: e.position,
          // pressureColor: getPressureColor(e.pressure),
          // temperatureColor: getTemperature(e.temperature),
          // shearForceColor: getShearForceColor(e.shearForceTotal),
          // shearForceLength: getShearForceRatio(e.shearForceTotal),
          // shearForceDirectionRadians: e.shearForceRadians,
          pressureColor: getMagZColor(e.magZ),
          temperatureColor: getTemperature(e.temperature),
          shearForceColor: getMagXYColor(e.magX, e.magY),
          shearForceLength: getMagXYRatio(e.magX, e.magY),
          shearForceDirectionRadians: getMagXYDirectionRadians(e.magX, e.magY),
        )))
      .fold([].cast<FootMapSensorUnitDto>(), (previousValue, element) => previousValue..addAll(element))
      .toList();
  }
}

class FootMapSensorUnitDto {
  Point<double> position;
  Color pressureColor;
  Color temperatureColor;
  Color shearForceColor;
  double shearForceLength;
  double shearForceDirectionRadians;
  FootMapSensorUnitDto({
    required this.position,
    required this.pressureColor,
    required this.temperatureColor,
    required this.shearForceColor,
    required this.shearForceLength,
    required this.shearForceDirectionRadians,
  });
}