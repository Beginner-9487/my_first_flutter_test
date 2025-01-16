import 'dart:async';

import 'package:utl_electrochemical_tester/application/domain/electrochemical_entity.dart';
import 'package:utl_electrochemical_tester/application/domain/value/electrochemical_data.dart';

abstract class InMemoryRepository {
  Iterable<ElectrochemicalEntity> get entities;
  void add(ElectrochemicalEntity entity);
  void update(ElectrochemicalEntity entity, ElectrochemicalData data);
  void clear();
  Stream<ElectrochemicalEntity> get onUpdate;
  Stream<void> get onClear;
}

class ConcreteInMemoryRepository extends InMemoryRepository {
  final StreamController<ElectrochemicalEntity?> _streamController = StreamController.broadcast();
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
    _streamController.add(entity);
  }
  @override
  void update(ElectrochemicalEntity entity, ElectrochemicalData data) {
    _entities.where((e) => e == entity).firstOrNull?.data.add(data);
    _streamController.add(entity);
  }
  @override
  void clear() {
    _entities.clear();
    _streamController.add(null);
  }
  @override
  Stream<ElectrochemicalEntity> get onUpdate => _streamController
      .stream
      .where((event) => event != null)
      .map((event) => event!);
  @override
  Stream<void> get onClear => _streamController
      .stream
      .where((event) => event == null);
}
