import 'dart:async';

import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';

abstract class InMemoryRepository {
  Iterable<ElectrochemicalEntity> get entities;
  void add(ElectrochemicalEntity entity);
  void update(ElectrochemicalEntity entity, ElectrochemicalData data);
  Stream<ElectrochemicalEntity> get onUpdate;
  void clear();
  Stream<void> get onClear;
}

class ConcreteInMemoryRepository extends InMemoryRepository {
  final List<ElectrochemicalEntity> _entities = [];
  final int maxLength;
  @override
  Iterable<ElectrochemicalEntity> get entities => _entities;
  ConcreteInMemoryRepository({
    required this.maxLength,
  });
  @override
  void add(ElectrochemicalEntity entity) {
    if(_entities.contains(entity)) {return;}
    _entities.add(entity);
    if(_entities.length > maxLength) {
      _entities.removeAt(0);
    }
    _onUpdate.add(entity);
  }
  @override
  void update(ElectrochemicalEntity entity, ElectrochemicalData data) {
    _entities.where((e) => e == entity).firstOrNull?.data.add(data);
    _onUpdate.add(entity);
  }
  final StreamController<ElectrochemicalEntity> _onUpdate = StreamController.broadcast();
  @override
  Stream<ElectrochemicalEntity> get onUpdate => _onUpdate.stream;
  final StreamController<void> _onClear = StreamController.broadcast();
  @override
  void clear() {
    _entities.clear();
    _onClear.add(null);
  }
  @override
  Stream<void> get onClear => _onClear.stream;
}
