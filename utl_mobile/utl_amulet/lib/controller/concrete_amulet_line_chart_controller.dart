import 'dart:async';
import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_amulet/adapter/adapter_dto_mapper.dart';
import 'package:utl_amulet/adapter/amulet_device/amulet_devices_manager.dart';
import 'package:utl_amulet/adapter/amulet_device/dto/amulet_device_data_dto.dart';
import 'package:utl_amulet/controller/amulet_line_chart_controller.dart';
import 'package:utl_amulet/controller/dto/amulet_line_chatr.dto.dart';
import 'package:utl_amulet/controller/dto/controller_dto_mapper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utl_amulet/domain/usecase/amulet_fetch_entities_process.dart';
import 'package:utl_amulet/service/amulet_entity_creator.dart';

class ConcreteAmuletLineChartSharedResource {
  final AmuletDevicesManager amuletDevicesManager;
  final AmuletEntityCreator amuletEntityCreator;

  double? xTime;
  bool _isTouched = false;
  AmuletDeviceDataDto? _firstDtoBuffer;
  List<AmuletDeviceDataDto> _dtoBuffer = [];
  List<AmuletDeviceDataDto> _dtoLineChartBuffer = [];

  late final StreamSubscription _clearSubscription;
  late final StreamSubscription _dataSubscription;

  final List<AmuletLineChartSeriesListChangeNotifier> _lineChartSeriesListChangeNotifiers = [];
  final List<AmuletLineChartInfoChangeNotifier> _lineChartInfoChangeNotifiers = [];

  late final AmuletLineChartController amuletLineChartController;
  late final AmuletLineChartInfoController amuletLineChartInfoController;
  ConcreteAmuletLineChartSharedResource({
    required this.amuletDevicesManager,
    required this.amuletEntityCreator,
    required AmuletFetchEntitiesProcessUsecase amuletFetchEntitiesProcessUsecase,
  }) {
    amuletLineChartController = ConcreteAmuletLineChartController._(this);
    amuletLineChartInfoController = ConcreteAmuletLineChartInfoController._(this);
    amuletFetchEntitiesProcessUsecase(
      processor: (entity) {
        if(entity == null) return true;
        final dto = AdapterDtoMapper.mapEntityToRepositoryInsertDto(
          entity: entity,
        );
        _dtoBuffer.add(dto);
        updateLineChartBuffer();
        return true;
      },
    );
    _clearSubscription = amuletDevicesManager.clearStream.listen((_) {
      _firstDtoBuffer = null;
      _dtoBuffer = [];
      _dtoLineChartBuffer = [];
      updateLineChartBuffer();
    });
    _dataSubscription = amuletDevicesManager.dtoBufferSyncStream.listen((dtoBuffer) {
      _dtoBuffer = dtoBuffer.toList();
      updateLineChartBuffer();
    });
  }

  updateLineChartBuffer() {
    _firstDtoBuffer ??= _dtoBuffer.firstOrNull;
    if(_isTouched) return;
    _dtoLineChartBuffer = _dtoBuffer;
    notifyListeners(
      seriesList: true,
      info: true,
    );
  }

  notifyListeners({
    required bool seriesList,
    required bool info,
  }) {
    if(seriesList) {
      for(var listener in _lineChartSeriesListChangeNotifiers) {
        listener.notifyListeners();
      }
    }
    if(info) {
      for(var listener in _lineChartInfoChangeNotifiers) {
        listener.notifyListeners();
      }
    }
  }
  bool get isTouched => _isTouched;
  void setIsTouched(bool isTouched) {
    _isTouched = isTouched;
    if(_isTouched) return;
  }
  void setX(double? x) {
    xTime = (x == null)
      ? x
      : x * 1e6;
    notifyListeners(
      seriesList: false,
      info: true,
    );
  }
  void dispose() {
    _clearSubscription.cancel();
    _dataSubscription.cancel();
    for(var listener in _lineChartSeriesListChangeNotifiers) {
      listener.dispose();
    }
    _lineChartSeriesListChangeNotifiers.clear();
    for(var listener in _lineChartInfoChangeNotifiers) {
      listener.dispose();
    }
    _lineChartInfoChangeNotifiers.clear();
  }
}

// Implementation of shared resources
class ConcreteAmuletLineChartSeriesListChangeNotifier
    extends AmuletLineChartSeriesListChangeNotifier {
  final ConcreteAmuletLineChartSharedResource resource;
  final AppLocalizations appLocalizations;

  ConcreteAmuletLineChartSeriesListChangeNotifier._(
      this.resource,
      this.appLocalizations,
  ) {
    resource._lineChartSeriesListChangeNotifiers.add(this);
  }

  @override
  List<LineSeries<Point<num>, double>> get seriesList {
    final firstDto = resource._firstDtoBuffer;
    if(firstDto == null) return [];
    return ControllerDtoMapper.deviceDataDtoToSeriesList(
      appLocalizations: appLocalizations,
      firstDto: resource._firstDtoBuffer!,
      dto: resource._dtoLineChartBuffer,
    );
  }

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartSeriesListChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteAmuletLineChartInfoChangeNotifier
    extends AmuletLineChartInfoChangeNotifier {
  final ConcreteAmuletLineChartSharedResource resource;

  ConcreteAmuletLineChartInfoChangeNotifier._(this.resource) {
    resource._lineChartInfoChangeNotifiers.add(this);
  }

  @override
  AmuletLineChartInfoDto? get info {
    final buffer = resource._dtoLineChartBuffer;
    if(buffer.isEmpty) return null;
    final first = resource._firstDtoBuffer;
    if(first == null) return null;
    final dto = buffer.where((d) => d.time.microsecondsSinceEpoch - (first.time.microsecondsSinceEpoch) == resource.xTime).firstOrNull;
    if(dto == null) return null;
    return ControllerDtoMapper.deviceDataDtoToInfoDto(
      dto: dto,
    );
  }

  @override
  double? get x => resource.xTime;

  @override
  String getXData() {
    final xTime = resource.xTime;
    if(xTime == null) return "";
    return (xTime / 1e6).toString();
  }

  @override
  String getXLabel({required AppLocalizations appLocalizations}) {
    return appLocalizations.time;
  }

  @override
  String getYData({required AmuletLineChartItem item}) {
    final info = this.info;
    if(info == null) return "";
    switch (item) {
      case AmuletLineChartItem.accX:
        return info.accX.toString();
      case AmuletLineChartItem.accY:
        return info.accY.toString();
      case AmuletLineChartItem.accZ:
        return info.accZ.toString();
      case AmuletLineChartItem.accTotal:
        return info.accTotal.toString();
      case AmuletLineChartItem.magX:
        return info.magX.toString();
      case AmuletLineChartItem.magY:
        return info.magY.toString();
      case AmuletLineChartItem.magZ:
        return info.magZ.toString();
      case AmuletLineChartItem.magTotal:
        return info.magTotal.toString();
      case AmuletLineChartItem.pitch:
        return info.pitch.toString();
      case AmuletLineChartItem.roll:
        return info.roll.toString();
      case AmuletLineChartItem.yaw:
        return info.yaw.toString();
      case AmuletLineChartItem.pressure:
        return info.pressure.toString();
      case AmuletLineChartItem.temperature:
        return info.temperature.toString();
      case AmuletLineChartItem.posture:
        return info.posture.name;
      case AmuletLineChartItem.adc:
        return info.adc.toString();
      case AmuletLineChartItem.battery:
        return info.battery.toString();
      case AmuletLineChartItem.area:
        return info.area.toString();
      case AmuletLineChartItem.step:
        return info.step.toString();
      case AmuletLineChartItem.direction:
        return info.direction.toString();
    }
  }

  @override
  String getYLabel({required AppLocalizations appLocalizations, required AmuletLineChartItem item}) {
    return ControllerDtoMapper.amuletLineChartItemToName(appLocalizations: appLocalizations, item: item);
  }

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartInfoChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteAmuletLineChartController
    implements AmuletLineChartController {
  final ConcreteAmuletLineChartSharedResource resource;

  ConcreteAmuletLineChartController._(this.resource);

  @override
  set x(double? x) => resource.setX(x);

  @override
  AmuletLineChartSeriesListChangeNotifier createSeriesListChangeNotifier({required AppLocalizations appLocalizations}) {
    return ConcreteAmuletLineChartSeriesListChangeNotifier._(resource, appLocalizations);
  }

  @override
  set isTouched(bool isTouched) => resource.setIsTouched(isTouched);

  @override
  bool get isTouched => resource.isTouched;

}

class ConcreteAmuletLineChartInfoController
    implements AmuletLineChartInfoController {
  final ConcreteAmuletLineChartSharedResource resource;

  ConcreteAmuletLineChartInfoController._(this.resource);

  @override
  AmuletLineChartInfoChangeNotifier createInfoChangeNotifier() {
    return ConcreteAmuletLineChartInfoChangeNotifier._(resource);
  }
}
