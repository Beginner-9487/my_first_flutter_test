import 'dart:async';
import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:utl_electrochemical_tester/controller/dto/controller_dto_mapper.dart';
import 'package:utl_electrochemical_tester/controller/dto/electrochemical_line_chart_info_dto.dart';
import 'package:utl_electrochemical_tester/controller/electrochemical_dashboard_controller.dart';
import 'package:utl_electrochemical_tester/domain/entity/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/domain/repository/electrochemical_entity_repository.dart';
import 'package:utl_electrochemical_tester/domain/usecase/process_electrochemical_entities_usecase.dart';
import 'package:utl_electrochemical_tester/domain/value/electrochemical_parameters.dart';

class SharedElectrochemicalLineChartResource {
  final ElectrochemicalEntityRepository electrochemicalEntityRepository;
  late final StreamSubscription _streamSubscription;
  final List<ElectrochemicalEntity> electrochemicalEntityBuffers = [];

  ElectrochemicalLineChartMode mode = ElectrochemicalLineChartMode.ampereIndex;
  final Map<ElectrochemicalType, bool> shows = Map.fromEntries(ElectrochemicalType.values.map((type) => MapEntry(type, true)));
  double? x;

  late final SharedLineChartSeriesListChangeNotifier lineChartSeriesListChangeNotifier;
  late final SharedLineChartDatasetInfoChangeNotifier lineChartDatasetInfoChangeNotifier;
  late final SharedLineChartDatasetModeChangeNotifier lineChartDatasetModeChangeNotifier;
  late final SharedLineChartDatasetTypesShowChangeNotifier lineChartDatasetTypesShowChangeNotifier;

  late final SharedElectrochemicalLineChartController electrochemicalLineChartController;
  late final SharedElectrochemicalLineChartInfoController electrochemicalLineChartInfoController;
  late final SharedElectrochemicalLineChartSetterController electrochemicalLineChartSetterController;
  SharedElectrochemicalLineChartResource({
    required this.electrochemicalEntityRepository,
    required ProcessElectrochemicalEntitiesUsecase processElectrochemicalEntitiesUsecase,
  }) {
    lineChartSeriesListChangeNotifier = SharedLineChartSeriesListChangeNotifier(this);
    lineChartDatasetInfoChangeNotifier = SharedLineChartDatasetInfoChangeNotifier(this);
    lineChartDatasetModeChangeNotifier = SharedLineChartDatasetModeChangeNotifier(this);
    lineChartDatasetTypesShowChangeNotifier = SharedLineChartDatasetTypesShowChangeNotifier(this);

    electrochemicalLineChartController = SharedElectrochemicalLineChartController(this);
    electrochemicalLineChartInfoController = SharedElectrochemicalLineChartInfoController(this);
    electrochemicalLineChartSetterController = SharedElectrochemicalLineChartSetterController(this);

    processElectrochemicalEntitiesUsecase(
      processor: (entity) {
        if(entity == null) return true;
        electrochemicalEntityBuffers.add(entity);
        notifyListeners();
        return true;
      }
    );

    _streamSubscription = electrochemicalEntityRepository.entitySyncStream.listen((entity) {
      electrochemicalEntityBuffers.add(entity);
      notifyListeners();
    });
  }
  notifyListeners() {
    lineChartSeriesListChangeNotifier.notifyListeners();
    lineChartDatasetInfoChangeNotifier.notifyListeners();
    lineChartDatasetModeChangeNotifier.notifyListeners();
    lineChartDatasetTypesShowChangeNotifier.notifyListeners();
  }
  void setMode(ElectrochemicalLineChartMode newMode) {
    mode = newMode;
    notifyListeners();
  }
  void setShow(ElectrochemicalType type, bool show) {
    shows[type] = show;
    notifyListeners();
  }
  void setX(double? x) {
    this.x = x;
    notifyListeners();
  }
  void dispose() {
    _streamSubscription.cancel();
    lineChartSeriesListChangeNotifier.dispose();
    lineChartDatasetInfoChangeNotifier.dispose();
    lineChartDatasetModeChangeNotifier.dispose();
    lineChartDatasetTypesShowChangeNotifier.dispose();
  }
}

// Implementation of shared resources
class SharedLineChartSeriesListChangeNotifier
    extends LineChartSeriesListChangeNotifier {
  final SharedElectrochemicalLineChartResource resource;

  SharedLineChartSeriesListChangeNotifier(this.resource);

  @override
  List<LineSeries<Point<num>, double>> get seriesList => ControllerDtoMapper.mapElectrochemicalEntitiesToLineChartSeriesList(
    entities: resource.electrochemicalEntityBuffers,
    mode: resource.mode,
  );

  @override
  notifyListeners() => super.notifyListeners();
}

class SharedLineChartDatasetInfoChangeNotifier
    extends LineChartInfoChangeNotifier {
  final SharedElectrochemicalLineChartResource resource;

  SharedLineChartDatasetInfoChangeNotifier(this.resource);

  @override
  List<ElectrochemicalLineChartInfoDto> get info => ControllerDtoMapper.mapElectrochemicalEntitiesToLineChartInfo(
    entities: resource.electrochemicalEntityBuffers,
    x: resource.x,
    mode: mode,
  );

  @override
  ElectrochemicalLineChartMode get mode => resource.mode;

  @override
  notifyListeners() => super.notifyListeners();
}

class SharedLineChartDatasetModeChangeNotifier
    extends LineChartDatasetModeChangeNotifier {
  final SharedElectrochemicalLineChartResource resource;

  SharedLineChartDatasetModeChangeNotifier(this.resource);

  @override
  ElectrochemicalLineChartMode get mode => resource.mode;

  @override
  notifyListeners() => super.notifyListeners();
}

class SharedLineChartDatasetTypesShowChangeNotifier
    extends LineChartDatasetTypesShowChangeNotifier {
  final SharedElectrochemicalLineChartResource resource;

  SharedLineChartDatasetTypesShowChangeNotifier(this.resource);

  @override
  Map<ElectrochemicalType, bool> get shows => resource.shows;

  @override
  notifyListeners() => super.notifyListeners();
}

class SharedElectrochemicalLineChartController
    implements ElectrochemicalLineChartController {
  final SharedElectrochemicalLineChartResource resource;

  SharedElectrochemicalLineChartController(this.resource);

  @override
  LineChartSeriesListChangeNotifier get lineChartSeriesListChangeNotifier =>
      resource.lineChartSeriesListChangeNotifier;

  @override
  set x(double? x) => resource.setX(x);
}

class SharedElectrochemicalLineChartInfoController
    implements ElectrochemicalLineChartInfoController {
  final SharedElectrochemicalLineChartResource resource;

  SharedElectrochemicalLineChartInfoController(this.resource);

  @override
  LineChartInfoChangeNotifier get lineChartInfoChangeNotifier =>
      resource.lineChartDatasetInfoChangeNotifier;
}

class SharedElectrochemicalLineChartSetterController
    implements ElectrochemicalLineChartSetterController {
  final SharedElectrochemicalLineChartResource resource;

  SharedElectrochemicalLineChartSetterController(this.resource);

  @override
  LineChartDatasetModeChangeNotifier get lineChartMode => resource.lineChartDatasetModeChangeNotifier;

  @override
  set mode(ElectrochemicalLineChartMode mode) => resource.setMode(mode);

  @override
  LineChartDatasetTypesShowChangeNotifier get lineChartTypesShow =>
      resource.lineChartDatasetTypesShowChangeNotifier;

  @override
  void setTypeShow({
    required ElectrochemicalType type,
    required bool show,
  }) {
    resource.setShow(type, show);
  }
}
