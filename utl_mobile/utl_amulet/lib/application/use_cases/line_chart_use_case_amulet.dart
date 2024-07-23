import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_r/r.dart';
import 'package:utl_amulet/application/domain/amulet_repository.dart';
import 'package:utl_mobile/application/use_cases/line_chart_use_case.dart';
import 'package:utl_mobile/utils/data_color_generator.dart';

class LineChartUseCaseAmulet extends LineChartUseCaseImpl {
  final AmuletRepository _repository;
  LineChartUseCaseAmulet(this._repository);

  static const int _SHOW_LINE_CHART_MAX_LENGTH = 100;
  static const int _ROUND = 100;

  bool showAcc = false;
  bool showGyro = false;
  bool showMag = false;
  bool showOthers = true;

  int get _numberOfDataForEachDevice {
    if(showAcc || showGyro || showMag) {
      return 3;
    }
    if(showOthers) {
      return 4;
    }
    return 0;
  }

  Iterable<(BLEDevice, Iterable<Color>)> _colors(Iterable<BLEDevice> devices) {
    double alpha = 1;
    return devices
      .indexed
      .map((device) => (
        device.$2,
        Iterable
          .generate(_numberOfDataForEachDevice)
          .map((e) => DataColorGenerator.rainbowLayer(
            alpha: alpha,
            currentLayerDataIndex: devices.length,
            currentLayerDataSize: devices.length,
            layerIndex: e,
            layerSize: _numberOfDataForEachDevice,
          )),
      ));
  }

  Iterable<(BLEDevice, Iterable<String>)> _labelNames(Iterable<BLEDevice> devices) {
    if(showAcc) {
      return devices.map((device) => (
        device,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return "${device.name}-${R.str.accX}";
            case 1:
              return "${device.name}-${R.str.accY}";
            case 2:
              return "${device.name}-${R.str.accZ}";
            default:
              throw Exception();
          }
        }),
      ));
    }
    if(showGyro) {
      return devices.map((device) => (
        device,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return "${device.name}-${R.str.gyroX}";
            case 1:
              return "${device.name}-${R.str.gyroY}";
            case 2:
              return "${device.name}-${R.str.gyroZ}";
            default:
              throw Exception();
          }
        }),
      ));
    }
    if(showMag) {
      return devices.map((device) => (
        device,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return "${device.name}-${R.str.magX}";
            case 1:
              return "${device.name}-${R.str.magY}";
            case 2:
              return "${device.name}-${R.str.magZ}";
            default:
              throw Exception();
          }
        }),
      ));
    }
    if(showOthers) {
      return devices.map((device) => (
        device,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return "${device.name}-${R.str.pitch}";
            case 1:
              return "${device.name}-${R.str.roll}";
            case 2:
              return "${device.name}-${R.str.yaw}";
            case 3:
              return "${device.name}-${R.str.gValue}";
            default:
              throw Exception();
          }
        }),
      ));
    }
    return const Iterable.empty();
  }

  Iterable<(BLEDevice, Iterable<Iterable<Point<double>>>)> _rowsToListPoints(Iterable<(BLEDevice, Iterable<AmuletRow>)> deviceWithRows) {
    if(showAcc) {
      return deviceWithRows.map((e) => (
        e.$1,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.accX * _ROUND).round() / _ROUND));
            case 1:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.accY * _ROUND).round() / _ROUND));
            case 2:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.accZ * _ROUND).round() / _ROUND));
            default:
              throw Exception();
          }
        }),
      ));
    }
    if(showGyro) {
      return deviceWithRows.map((e) => (
        e.$1,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.gyroX * _ROUND).round() / _ROUND));
            case 1:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.gyroY * _ROUND).round() / _ROUND));
            case 2:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.gyroZ * _ROUND).round() / _ROUND));
            default:
              throw Exception();
          }
        }),
      ));
    }
    if(showMag) {
      return deviceWithRows.map((e) => (
        e.$1,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.magX * _ROUND).round() / _ROUND));
            case 1:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.magY * _ROUND).round() / _ROUND));
            case 2:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.magZ * _ROUND).round() / _ROUND));
            default:
              throw Exception();
          }
        }),
      ));
    }
    if(showOthers) {
      return deviceWithRows.map((e) => (
        e.$1,
        Iterable.generate(_numberOfDataForEachDevice, (int n) {
          switch(n) {
            case 0:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.pitch * _ROUND).round() / _ROUND));
            case 1:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.roll * _ROUND).round() / _ROUND));
            case 2:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.yaw * _ROUND).round() / _ROUND));
            case 3:
              return e.$2.map((row) => Point((row.time * _ROUND).round() / _ROUND, (row.gValue * _ROUND).round() / _ROUND));
            default:
              throw Exception();
          }
        }),
      ));
    }
    return const Iterable.empty();
  }

  Iterable<BLEDevice> get _devices => _repository.devicesRows
      .indexed
      .where((element) => deviceIndexOfNonNullRows.contains(element.$1))
      .map((e) => e.$2.$1);
  Iterable<Iterable<AmuletRow>> get _rows => _repository.devicesRows
      .map((e) => e.$2
        .skip((e.$2.length > _SHOW_LINE_CHART_MAX_LENGTH) ? (e.$2.length - _SHOW_LINE_CHART_MAX_LENGTH) : 0));
  Iterable<(BLEDevice, Iterable<AmuletRow>)> get _devicesWithRows => _repository.devicesRows
      .map((e) => (
        e.$1,
        e.$2
            .skip((e.$2.length > _SHOW_LINE_CHART_MAX_LENGTH) ? (e.$2.length - _SHOW_LINE_CHART_MAX_LENGTH) : 0),
      ));

  Iterable<int> get deviceIndexOfNonNullRows => _devicesWithRows
      .indexed
      .where((element) => element.$2.$2.isNotEmpty)
      .map((e) => e.$1);
  Iterable<Color> get colors => _colors(_devices)
      .indexed
      .where((element) => deviceIndexOfNonNullRows.contains(element.$1))
      .map((e) => e.$2.$2)
      .reduce((value, element) => value.followedBy(element));
  Iterable<String> get labelNames => _labelNames(_devices)
      .indexed
      .where((element) => deviceIndexOfNonNullRows.contains(element.$1))
      .map((e) => e.$2.$2)
      .reduce((value, element) => value.followedBy(element));
  Iterable<Iterable<Point<double>>> get pointsIterable {
    Iterable<Iterable<Iterable<Point<double>>>> pointsListOfEachDevice = _rowsToListPoints(
            _devicesWithRows
                .where((element) => element.$2.isNotEmpty)
        )
        .map((e) => e.$2);

    Iterable<Iterable<Point<double>>> pointsList;
    if(pointsListOfEachDevice.isEmpty) {
      pointsList = const Iterable.empty();
    } else if(pointsListOfEachDevice.length == 1) {
      pointsList = pointsListOfEachDevice.first;
    } else {
      pointsList = pointsListOfEachDevice
          .reduce((value, element) => value.followedBy(element));
    }
    return pointsList;
  }
  List<List<Point<double>>> get pointsList => fillTwoSidePoints(pointsIterable);

  @override
  Iterable<LineChartCurveRow> get curveRow {
    if(deviceIndexOfNonNullRows.isEmpty) {
      return [];
    }
    return pointsList.indexed
        .map((points) => LineChartCurveRow(
              name: labelNames.skip(points.$1).first,
              points: points.$2,
              color: colors.skip(points.$1).first,
            ))
        .toList();
  }

  @override
  List<LineChartDashboardRow> get dashBoardRows {
    if(deviceIndexOfNonNullRows.isEmpty) {
      return [];
    }
    return pointsList.indexed
        .map((points) => LineChartDashboardRow(
              color: colors.skip(points.$1).first,
              name: labelNames.skip(points.$1).first,
              points: points.$2,
              xLabelName: R.str.time,
              yLabelName: "y",
              xUnitName: "s",
              yUnitName: "yu",
            ))
        .toList();
  }
}