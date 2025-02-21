import 'dart:math';
import 'dart:ui';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_amulet/adapter/amulet_device/dto/amulet_device_data_dto.dart';
import 'package:utl_amulet/controller/dto/amulet_line_chatr.dto.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AmuletLineChartItem {
  accX,
  accY,
  accZ,
  accTotal,
  magX,
  magY,
  magZ,
  magTotal,
  pitch,
  roll,
  yaw,
  pressure,
  temperature,
  posture,
  adc,
  battery,
  area,
  step,
  direction,
}

const Map<AmuletLineChartItem, Color> amuletSeriesItemColors = {
  AmuletLineChartItem.accX: Color(0xFFF4A261),      // 淺橘
  AmuletLineChartItem.accY: Color(0xFF2A9D8F),      // 青綠
  AmuletLineChartItem.accZ: Color(0xFFE76F51),      // 紅橙
  AmuletLineChartItem.accTotal: Color(0xFF264653),  // 深藍灰
  AmuletLineChartItem.magX: Color(0xFFE9C46A),      // 黃金色
  AmuletLineChartItem.magY: Color(0xFF8AB17D),      // 草綠
  AmuletLineChartItem.magZ: Color(0xFFD62828),      // 深紅
  AmuletLineChartItem.magTotal: Color(0xFF023047),  // 深藍
  AmuletLineChartItem.pitch: Color(0xFFFFB703),     // 亮黃
  AmuletLineChartItem.roll: Color(0xFFFB8500),      // 橘黃
  AmuletLineChartItem.yaw: Color(0xFF219EBC),       // 天藍
  AmuletLineChartItem.pressure: Color(0xFFCDB4DB),  // 淡紫
  AmuletLineChartItem.temperature: Color(0xFFFF006E), // 粉紅
  AmuletLineChartItem.posture: Color(0xFF6A0572),   // 紫色
  AmuletLineChartItem.adc: Color(0xFF8338EC),       // 深紫
  AmuletLineChartItem.battery: Color(0xFF3A86FF),   // 天空藍
  AmuletLineChartItem.area: Color(0xFF80ED99),      // 淺綠
  AmuletLineChartItem.step: Color(0xFFFF99C8),      // 淺粉紅
  AmuletLineChartItem.direction: Color(0xFFB56576), // 暗紅
};

class ControllerDtoMapper {
  ControllerDtoMapper._();
  static String amuletLineChartItemToName({
    required AppLocalizations appLocalizations,
    required AmuletLineChartItem item,
  }) {
    switch (item) {
      case AmuletLineChartItem.accX:
        return appLocalizations.accX;
      case AmuletLineChartItem.accY:
        return appLocalizations.accY;
      case AmuletLineChartItem.accZ:
        return appLocalizations.accZ;
      case AmuletLineChartItem.accTotal:
        return appLocalizations.accTotal;
      case AmuletLineChartItem.magX:
        return appLocalizations.magX;
      case AmuletLineChartItem.magY:
        return appLocalizations.magY;
      case AmuletLineChartItem.magZ:
        return appLocalizations.magZ;
      case AmuletLineChartItem.magTotal:
        return appLocalizations.magTotal;
      case AmuletLineChartItem.pitch:
        return appLocalizations.pitch;
      case AmuletLineChartItem.roll:
        return appLocalizations.roll;
      case AmuletLineChartItem.yaw:
        return appLocalizations.yaw;
      case AmuletLineChartItem.pressure:
        return appLocalizations.pressure;
      case AmuletLineChartItem.temperature:
        return appLocalizations.temperature;
      case AmuletLineChartItem.posture:
        return appLocalizations.posture;
      case AmuletLineChartItem.adc:
        return appLocalizations.adc;
      case AmuletLineChartItem.battery:
        return appLocalizations.battery;
      case AmuletLineChartItem.area:
        return appLocalizations.area;
      case AmuletLineChartItem.step:
        return appLocalizations.step;
      case AmuletLineChartItem.direction:
        return appLocalizations.direction;
    }
  }

  static List<Point<num>> deviceDataDtoToDataSource({
    required Iterable<AmuletDeviceDataDto> dto,
    required DateTime startDateTime,
    required AmuletLineChartItem item,
  }) {
    return dto.map((d) {
      num x = (d.time.microsecondsSinceEpoch - startDateTime.microsecondsSinceEpoch) / 1e6;
      num y;

      switch (item) {
        case AmuletLineChartItem.accX:
          y = d.accX;
          break;
        case AmuletLineChartItem.accY:
          y = d.accY;
          break;
        case AmuletLineChartItem.accZ:
          y = d.accZ;
          break;
        case AmuletLineChartItem.accTotal:
          y = d.accTotal;
          break;
        case AmuletLineChartItem.magX:
          y = d.magX;
          break;
        case AmuletLineChartItem.magY:
          y = d.magY;
          break;
        case AmuletLineChartItem.magZ:
          y = d.magZ;
          break;
        case AmuletLineChartItem.magTotal:
          y = d.magTotal;
          break;
        case AmuletLineChartItem.pitch:
          y = d.pitch;
          break;
        case AmuletLineChartItem.roll:
          y = d.roll;
          break;
        case AmuletLineChartItem.yaw:
          y = d.yaw;
          break;
        case AmuletLineChartItem.pressure:
          y = d.pressure;
          break;
        case AmuletLineChartItem.temperature:
          y = d.temperature;
          break;
        case AmuletLineChartItem.posture:
          y = d.posture.index;
          break;
        case AmuletLineChartItem.adc:
          y = d.adc;
          break;
        case AmuletLineChartItem.battery:
          y = d.battery;
          break;
        case AmuletLineChartItem.area:
          y = d.area;
          break;
        case AmuletLineChartItem.step:
          y = d.step;
          break;
        case AmuletLineChartItem.direction:
          y = d.direction;
          break;
      }

      return Point(x, y);
    }).toList();
  }


  static LineSeries<Point<num>, double> deviceDataDtoToSeries({
    required AppLocalizations appLocalizations,
    required AmuletDeviceDataDto firstDto,
    required Iterable<AmuletDeviceDataDto> dto,
    required AmuletLineChartItem item,
  }) {
    return LineSeries<Point, double>(
      name: amuletLineChartItemToName(
        appLocalizations: appLocalizations,
        item: item,
      ),
      dataSource: deviceDataDtoToDataSource(
        dto: dto,
        startDateTime: firstDto.time,
        item: item,
      ),
      animationDuration: 0,
      xValueMapper: (Point data, _) => data.x.toDouble(),
      yValueMapper: (Point data, _) => data.y.toDouble(),
      color: amuletSeriesItemColors[item],
      width: 1.5,
      // markerSettings: MarkerSettings(isVisible: true),
    );
  }

  static List<LineSeries<Point<num>, double>> deviceDataDtoToSeriesList({
    required AppLocalizations appLocalizations,
    required AmuletDeviceDataDto firstDto,
    required Iterable<AmuletDeviceDataDto> dto,
  }) {
    if(dto.isEmpty) return [];
    return AmuletLineChartItem.values.map((item) => deviceDataDtoToSeries(
      appLocalizations: appLocalizations,
      firstDto: firstDto,
      dto: dto,
      item: item,
    )).toList();
  }

  static AmuletLineChartInfoDto deviceDataDtoToInfoDto({
    required AmuletDeviceDataDto dto,
  }) {
    return AmuletLineChartInfoDto(
      deviceId: dto.deviceId,
      time: dto.time,
      accX: dto.accX,
      accY: dto.accY,
      accZ: dto.accZ,
      accTotal: dto.accTotal,
      magX: dto.magX,
      magY: dto.magY,
      magZ: dto.magZ,
      magTotal: dto.magTotal,
      pitch: dto.pitch,
      roll: dto.roll,
      yaw: dto.yaw,
      pressure: dto.pressure,
      temperature: dto.temperature,
      posture: dto.posture,
      adc: dto.adc,
      battery: dto.battery,
      area: dto.area,
      step: dto.step,
      direction: dto.direction,
    );
  }

  static AmuletDeviceDataDto infoDtoToDeviceDataDto(AmuletLineChartInfoDto data) {
    return AmuletDeviceDataDto(
      deviceId: data.deviceId,
      time: data.time,
      accX: data.accX,
      accY: data.accY,
      accZ: data.accZ,
      accTotal: data.accTotal,
      magX: data.magX,
      magY: data.magY,
      magZ: data.magZ,
      magTotal: data.magTotal,
      pitch: data.pitch,
      roll: data.roll,
      yaw: data.yaw,
      pressure: data.pressure,
      temperature: data.temperature,
      posture: data.posture,
      adc: data.adc,
      battery: data.battery,
      area: data.area,
      step: data.step,
      direction: data.direction,
    );
  }
}
