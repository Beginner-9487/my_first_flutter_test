import 'dart:async';

import 'package:utl_leakage/application/domain/leakage_repository.dart';

class LeakageRepositoryImpl extends LeakageRepository<LeakageRowImpl> {
  final List<(double, List<int>)> _rawData = [];
  @override
  Iterable<LeakageRowImpl> get rows => _rawData.indexed.map((e) => LeakageRowImpl(this, e.$1));
  add(double time, List<int> raw) {
    _rawData.add((time, raw));
    if(_rawData.length > LeakageRepository.ROW_MAX_LENGTH) {
      _rawData.removeAt(0);
    }
    _onAddController.sink.add(LeakageRowImpl(this, _rawData.length - 1));
  }
  final StreamController<LeakageRow> _onAddController = StreamController.broadcast();
  @override
  StreamSubscription<LeakageRow> onAdd(void Function(LeakageRow entity) doSomething) {
    return _onAddController.stream.listen((event) {
      doSomething(event);
    });
  }
}

class LeakageRowImpl extends LeakageRow {
  final LeakageRepositoryImpl _repositoryImpl;
  LeakageRowImpl(this._repositoryImpl, this.index);
  (double, List<int>) get _rawData => _repositoryImpl._rawData[index];
  List<int> get _raw => _repositoryImpl._rawData[index].$2;
  @override
  int index;
  @override
  double get time => _rawData.$1;
  @override
  bool get isExtraLeakage => extraVoltage > LeakageRepository.EXTRA_LEAKAGE_WARNING_VOLTAGE;
  @override
  bool get isIntraOsmosis => intraCapacitance > LeakageRepository.INTRA_LEAKAGE_WARNING_CAPACITANCE;
  @override
  double get extraVoltage => _raw[0].toDouble();
  @override
  double get intraCapacitance => _raw[1].toDouble();
}