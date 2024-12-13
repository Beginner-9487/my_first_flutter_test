import 'dart:async';

import 'package:utl_electrochemical_tester/application/data/electrochemical_data.dart';
import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';

abstract class InMemoryRepository {
  void add(ElectrochemicalDataEntity entity);
  void update(ElectrochemicalDataEntity entity, ElectrochemicalData data);
  Iterable<ElectrochemicalDataEntity> get entities;
  Stream<ElectrochemicalDataEntity> get onUpdate;
}

class ConcreteInMemoryRepository extends InMemoryRepository {
  final List<ElectrochemicalDataEntity> _entities = [];
  final int maxLength;
  final StreamController<ElectrochemicalDataEntity> _onUpdate = StreamController();
  ConcreteInMemoryRepository(this.maxLength);
  @override
  void add(ElectrochemicalDataEntity entity) {
    if(_entities.contains(entity)) {return;}
    _entities.add(entity);
    if(_entities.length > maxLength) {
      _entities.removeAt(0);
    }
    _onUpdate.add(entity);
  }
  @override
  void update(ElectrochemicalDataEntity entity, ElectrochemicalData data) {
    _entities.where((e) => e == entity).firstOrNull?.data.add(data);
    _onUpdate.add(entity);
  }
  @override
  Iterable<ElectrochemicalDataEntity> get entities => _entities;
  @override
  Stream<ElectrochemicalDataEntity> get onUpdate => _onUpdate.stream;
}
