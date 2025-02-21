import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/dto/controller_dto_mapper.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_line_chart_controller.dart';
import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';
import 'package:utl_electrochemical_tester/domain/usecase/process_electrochemical_entities_usecase.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class ConcreteElectrochemicalLineChartSharedResource {
  final ElectrochemicalEntityRepository electrochemicalEntityRepository;
  final List<ElectrochemicalEntity> electrochemicalEntityBuffers = [];

  late final StreamSubscription _syncStreamSubscription;
  late final StreamSubscription _removedStreamSubscription;

  ElectrochemicalLineChartMode mode = ElectrochemicalLineChartMode.ampereIndex;
  final Map<ElectrochemicalType, bool> shows = Map.fromEntries(ElectrochemicalType.values.map((type) => MapEntry(type, true)));
  double? x;

  final List<ConcreteLineChartSeriesListChangeNotifier> _lineChartSeriesListChangeNotifiers = [];
  final List<ConcreteLineChartInfoListChangeNotifier> _lineChartInfoListChangeNotifiers = [];
  final List<LineChartXChangeNotifier> _lineChartXChangeNotifiers = [];
  final List<ConcreteLineChartModeChangeNotifier> _lineChartModeChangeNotifiers = [];
  final List<ConcreteLineChartTypesShowChangeNotifier> _lineChartTypesShowChangeNotifiers = [];

  late final ConcreteElectrochemicalLineChartController electrochemicalLineChartController;
  late final ConcreteElectrochemicalLineChartInfoController electrochemicalLineChartInfoController;
  late final ConcreteElectrochemicalLineChartSetterController electrochemicalLineChartSetterController;
  ConcreteElectrochemicalLineChartSharedResource({
    required this.electrochemicalEntityRepository,
  }) {
    electrochemicalLineChartController = ConcreteElectrochemicalLineChartController._(this);
    electrochemicalLineChartInfoController = ConcreteElectrochemicalLineChartInfoController._(this);
    electrochemicalLineChartSetterController = ConcreteElectrochemicalLineChartSetterController._(this);

    var processElectrochemicalEntitiesUsecase = ProcessElectrochemicalEntitiesUsecase(
        electrochemicalEntityRepository: electrochemicalEntityRepository
    );

    processElectrochemicalEntitiesUsecase(
      processor: (entity) {
        if(entity == null) return true;
        electrochemicalEntityBuffers.add(entity);
        notifyListeners(seriesList: true, info: true, x: false, mode: false, typesShow: false);
        return true;
      },
    );

    _syncStreamSubscription = electrochemicalEntityRepository.entitySyncStream.listen((entity) {
      int index = electrochemicalEntityBuffers.indexOf(entity);
      index != -1
        ? electrochemicalEntityBuffers[index] = entity
        : electrochemicalEntityBuffers.add(entity);
      notifyListeners(seriesList: true, info: true, x: false, mode: false, typesShow: false);
    });

    _removedStreamSubscription = electrochemicalEntityRepository.entityRemovedStream.listen((entityId) {
      electrochemicalEntityBuffers.removeWhere((entity) => entity.id == entityId);
      notifyListeners(seriesList: true, info: true, x: false, mode: false, typesShow: false);
    });
  }
  notifyListeners({
    required bool seriesList,
    required bool info,
    required bool x,
    required bool mode,
    required bool typesShow,
  }) {
    if(seriesList) {
      for(var listener in _lineChartSeriesListChangeNotifiers) {
        listener.notifyListeners();
      }
    }
    if(info) {
      for(var listener in _lineChartInfoListChangeNotifiers) {
        listener.notifyListeners();
      }
    }
    if(x) {
      for(var listener in _lineChartXChangeNotifiers) {
        listener.notifyListeners();
      }
    }
    if(mode) {
      for(var listener in _lineChartModeChangeNotifiers) {
        listener.notifyListeners();
      }
    }
    if(typesShow) {
      for(var listener in _lineChartTypesShowChangeNotifiers) {
        listener.notifyListeners();
      }
    }
  }
  void setMode(ElectrochemicalLineChartMode newMode) {
    mode = newMode;
    x = null;
    notifyListeners(seriesList: true, info: true, x: true, mode: true, typesShow: false);
  }
  void setShow(ElectrochemicalType type, bool show) {
    shows[type] = show;
    notifyListeners(seriesList: true, info: true, x: false, mode: false, typesShow: true);
  }
  void setX(double? x) {
    this.x = x;
    notifyListeners(seriesList: false, info: true, x: true, mode: false, typesShow: true);
  }
  void dispose() {
    _syncStreamSubscription.cancel();
    _removedStreamSubscription.cancel();
    for(var listener in _lineChartSeriesListChangeNotifiers) {
      listener.dispose();
    }
    _lineChartSeriesListChangeNotifiers.clear();
    for(var listener in _lineChartInfoListChangeNotifiers) {
      listener.dispose();
    }
    _lineChartInfoListChangeNotifiers.clear();
    for(var listener in _lineChartXChangeNotifiers) {
      listener.dispose();
    }
    _lineChartXChangeNotifiers.clear();
    for(var listener in _lineChartModeChangeNotifiers) {
      listener.dispose();
    }
    _lineChartModeChangeNotifiers.clear();
    for(var listener in _lineChartTypesShowChangeNotifiers) {
      listener.dispose();
    }
    _lineChartTypesShowChangeNotifiers.clear();
  }
}

// Implementation of shared resources
class ConcreteLineChartSeriesListChangeNotifier
    extends LineChartSeriesListChangeNotifier {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteLineChartSeriesListChangeNotifier._(this.resource) {
    resource._lineChartSeriesListChangeNotifiers.add(this);
  }

  @override
  List<LineSeries<Point<num>, double>> get seriesList => ControllerDtoMapper.mapElectrochemicalEntitiesToLineChartSeriesList(
    entities: resource.electrochemicalEntityBuffers,
    mode: resource.mode,
    shows: resource.shows,
  );

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartSeriesListChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteLineChartInfoListChangeNotifier
    extends LineChartInfoListChangeNotifier {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteLineChartInfoListChangeNotifier._(this.resource) {
    resource._lineChartInfoListChangeNotifiers.add(this);
  }

  @override
  List<ElectrochemicalLineChartInfoDto> get infoList => ControllerDtoMapper.mapElectrochemicalEntitiesToLineChartInfo(
    entities: resource.electrochemicalEntityBuffers,
    x: resource.x,
    mode: resource.mode,
    shows: resource.shows,
  );

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartInfoListChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteLineChartXChangeNotifier
    extends LineChartXChangeNotifier {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteLineChartXChangeNotifier._(this.resource) {
    resource._lineChartXChangeNotifiers.add(this);
  }

  @override
  double? get x => resource.x;

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartXChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteLineChartModeChangeNotifier
    extends LineChartModeChangeNotifier {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteLineChartModeChangeNotifier._(this.resource) {
    resource._lineChartModeChangeNotifiers.add(this);
  }

  @override
  ElectrochemicalLineChartMode get mode => resource.mode;

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartModeChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteLineChartTypesShowChangeNotifier
    extends LineChartTypesShowChangeNotifier {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteLineChartTypesShowChangeNotifier._(this.resource) {
    resource._lineChartTypesShowChangeNotifiers.add(this);
  }

  @override
  Map<ElectrochemicalType, bool> get shows => resource.shows;

  @override
  notifyListeners() => super.notifyListeners();

  @override
  void dispose() {
    resource._lineChartTypesShowChangeNotifiers.remove(this);
    super.dispose();
  }
}

class ConcreteElectrochemicalLineChartController
    implements ElectrochemicalLineChartController {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteElectrochemicalLineChartController._(this.resource);

  @override
  LineChartSeriesListChangeNotifier createLineChartSeriesListChangeNotifier(BuildContext context) {
    return ConcreteLineChartSeriesListChangeNotifier._(resource);
  }

  @override
  set x(double? x) => resource.setX(x);
}

class ConcreteElectrochemicalLineChartInfoController
    implements ElectrochemicalLineChartInfoController {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteElectrochemicalLineChartInfoController._(this.resource);

  @override
  LineChartInfoListChangeNotifier createLineChartInfoListChangeNotifier(BuildContext context) {
    return ConcreteLineChartInfoListChangeNotifier._(resource);
  }

  @override
  LineChartModeChangeNotifier createLineChartModeChangeNotifier(BuildContext context) {
    return ConcreteLineChartModeChangeNotifier._(resource);
  }

  @override
  LineChartXChangeNotifier createLineChartXChangeNotifier(BuildContext context) {
    return ConcreteLineChartXChangeNotifier._(resource);
  }

  // @override
  // void deleteInfo({required ElectrochemicalLineChartInfoDto info}) {
  //   // TODO: implement deleteInfo
  // }
  //
  // @override
  // void renameInfo({required ElectrochemicalLineChartInfoDto info, required String newName}) {
  //   // TODO: implement renameInfo
  // }
}

class ConcreteElectrochemicalLineChartSetterController
    implements ElectrochemicalLineChartSetterController {
  final ConcreteElectrochemicalLineChartSharedResource resource;

  ConcreteElectrochemicalLineChartSetterController._(this.resource);

  @override
  LineChartModeChangeNotifier createLineChartModeChangeNotifier(BuildContext context) {
    return ConcreteLineChartModeChangeNotifier._(resource);
  }

  @override
  set mode(ElectrochemicalLineChartMode mode) => resource.setMode(mode);

  @override
  LineChartTypesShowChangeNotifier createLineChartTypesShowChangeNotifier(BuildContext context) {
    return ConcreteLineChartTypesShowChangeNotifier._(resource);
  }

  @override
  void setTypeShow({
    required ElectrochemicalType type,
    required bool show,
  }) {
    resource.setShow(type, show);
  }
}
