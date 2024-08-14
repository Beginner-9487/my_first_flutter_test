import 'dart:async';

import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';

int _rawToType(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[0],
    ],
    little: false,
  );
}

int _rawToNumberOfData(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[1],
      raw[2],
    ],
    little: false,
  );
}

int _rawToIndex(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[3],
      raw[4],
    ],
    little: false,
  );
}

double get _xPrecision => 1000.0;
double _rawToVoltage(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[5],
      raw[6],
    ],
    little: false,
  ) + (BytesConverter.byteArrayToInt16(
    [
      raw[7],
      raw[8],
    ],
    little: false,
  ).toDouble() / _xPrecision);
}

double get _yPrecision => 1000000.0;
double _rawToCurrent(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[9],
      raw[10],
    ],
    little: false,
  ) + (BytesConverter.byteArrayToInt32(
    [
      raw[11],
      raw[12],
      raw[13],
      raw[14],
    ],
    little: false,
  ).toDouble() / _yPrecision);
}

class MackayIRBRepositoryImpl extends MackayIRBRepository {
  static MackayIRBRepositoryImpl? _instance;
  static MackayIRBRepositoryImpl getInstance() {
    _instance ??= MackayIRBRepositoryImpl._();
    return _instance!;
  }
  MackayIRBRepositoryImpl._();

  @override
  List<MackayIRBEntity> entities = [];
  @override
  Iterable<MackayIRBEntity> get finishedEntities => entities
      .where((entity) => entity.finished)
      .toList();
  @override
  Iterable<MackayIRBEntity> get unfinishedEntities => entities
      .where((entity) => !entity.finished)
      .toList();

  int _currentId = 0;

  int get _nextId {
    return _currentId++;
  }

  @override
  MackayIRBEntity? findEntityById(int id) {
    return entities
        .where((entity) => entity.id == id)
        .firstOrNull;
  }

  MackayIRBEntity createNextEntity({
    required String name,
    required List<int> raw,
  }) {
    MackayIRBEntity entity = MackayIRBEntityImpl(
      repository: this,
      id: _nextId,
      name: name,
      type: _rawToType(raw),
      numberOfData: _rawToNumberOfData(raw),
    );
    entities.add(entity);
    _onCreateController.sink.add(entity);
    return entity;
  }

  final StreamController<MackayIRBRow> _onAddController = StreamController.broadcast();
  final StreamController<MackayIRBEntity> _onCreateController = StreamController.broadcast();
  final StreamController<MackayIRBEntity> _onFinishController = StreamController.broadcast();

  @override
  delete({int start = 0, int end = -1}) {
    if(start < 0) {
      start = 0;
    } else if(start >= entities.length) {
      start = entities.length - 1;
    }
    if(end > entities.length || end == -1) {
      end = entities.length;
    } else if(end < start) {
      end = start;
    }
    entities.removeRange(start, end);
  }

  @override
  Iterable<MackayIRBEntity> getEntitiesByType(int type) {
    return entities
        .where((entity) => entity.type == type)
        .toList();
  }

  @override
  StreamSubscription<MackayIRBEntity> onEntityCreated(void Function(MackayIRBEntity entity) doSomething) {
    return _onCreateController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<MackayIRBEntity> onEntityFinished(void Function(MackayIRBEntity entity) doSomething) {
    return _onFinishController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<MackayIRBRow> onNewRowAdded(void Function(MackayIRBRow entity) doSomething) {
    return _onAddController.stream.listen(doSomething);
  }
}

class MackayIRBEntityImpl extends MackayIRBEntity {
  final MackayIRBRepositoryImpl _repository;
  @override
  int id;
  @override
  List<MackayIRBRow> rows = [];
  @override
  String name;
  @override
  int type;
  @override
  int numberOfData;
  @override
  bool finished;

  MackayIRBEntityImpl(
      {
        required MackayIRBRepositoryImpl repository,
        required this.id,
        this.name = "",
        this.type = MackayIRBType.NULL,
        this.numberOfData = 0,
        this.finished = false,
      }
  ) : _repository = repository;

  add(List<int> raw) {
    if(finished) {return;}
    MackayIRBRow row = MackayIRBRowImpl(
        entity: this,
        raw: raw,
    );
    rows.add(row);
    _repository._onAddController.sink.add(row);
    if(row.index >= numberOfData) {
      finish();
    }
  }
  finish() {
    finished = true;
    _repository._onFinishController.sink.add(this);
  }

  @override
  List<int> get props => [id];

  @override
  StreamSubscription<MackayIRBRow> onAdded(void Function(MackayIRBRow row) doSomething) {
    return _repository._onAddController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<MackayIRBEntity> onCreated(void Function(MackayIRBEntity entity) doSomething) {
    return _repository._onCreateController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<MackayIRBEntity> onFinished(void Function(MackayIRBEntity entity) doSomething) {
    return _repository._onFinishController.stream.listen(doSomething);
  }
}

class MackayIRBRowImpl extends MackayIRBRow {
  List<int> raw;
  @override
  MackayIRBEntity entity;
  @override
  int get index => _rawToIndex(raw);
  @override
  double get current => _rawToCurrent(raw);
  @override
  double get voltage => _rawToVoltage(raw);
  MackayIRBRowImpl({
    required this.entity,
    required this.raw,
  });
}