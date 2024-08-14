import 'dart:async';
import 'dart:math';

import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_foot/application/domain/foot_repository.dart';
import 'package:utl_foot/application/domain/foot_sensor_position.dart';
import 'package:utl_foot/resources/ai_model.dart';

int _getBodyPart(List<int> raw) {
  return raw[0];
}

const _SENSOR_RAW_START_INDEX = 25;
const _SENSOR_RAW_LENGTH = 7;

class FootRepositoryImpl extends FootRepository<(double, List<int>)> {
  static FootRepositoryImpl? _instance;
  static FootRepositoryImpl getInstance() {
    _instance ??= FootRepositoryImpl._();
    return _instance!;
  }
  FootRepositoryImpl._() {
    entities = [
      FootEntityImpl(this, BodyPart.LEFT_FOOT),
      FootEntityImpl(this, BodyPart.RIGHT_FOOT),
    ];
  }

  late Timer timerUseAI;

  static const int _MAX_STORAGE_TIME_SECONDS = 5;

  int _rowIdCounter = 0;

  @override
  late List<FootEntityImpl> entities;
  FootEntityImpl _findEntity(int bodyPart) {
    switch(bodyPart) {
      case BodyPart.LEFT_FOOT:
        return entities[0];
      case BodyPart.RIGHT_FOOT:
        return entities[1];
    }
    throw Exception("No this bodyPart");
  }

  final StreamController<FootEntity> _onNewRowAddedController = StreamController.broadcast();
  final StreamController<FootRow> _onNewRowAddedControllerRow = StreamController.broadcast();
  final StreamController<FootEntity> _onNewRowFinishedController = StreamController.broadcast();
  final StreamController<FootRow> _onNewRowFinishedControllerRow = StreamController.broadcast();

  @override
  StreamSubscription<FootEntity> onNewRowAdded(void Function(FootEntity entity) doSomething) {
    return _onNewRowAddedController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<FootRow> onNewRowAddedRow(void Function(FootRow row) doSomething) {
    return _onNewRowAddedControllerRow.stream.listen(doSomething);
  }

  @override
  StreamSubscription<FootEntity> onNewRowFinished(void Function(FootEntity entity) doSomething) {
    return _onNewRowFinishedController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<FootRow> onNewRowFinishedRow(void Function(FootRow row) doSomething) {
    return _onNewRowFinishedControllerRow.stream.listen(doSomething);
  }

  @override
  FootEntity findEntityByBodyPart(int bodyPart) {
    return FootEntityImpl(this, bodyPart);
  }

  @override
  add((double, List<int>) rowData) async {
    int bodyPart = _getBodyPart(rowData.$2);
    var entity = _findEntity(bodyPart);
    var row = FootRowImpl(
      this,
      entity,
      _rowIdCounter++,
      rowData.$1,
      rowData.$2,
    );
    entity.rows.add(row);
    _deleteOldData(entity.rows.last.time);
    _onNewRowAddedController.sink.add(entity);
    _onNewRowAddedControllerRow.sink.add(row);
  }

  _deleteOldData(double currentTime) {
    for(var entity in entities) {
      if(entity.rows.isNotEmpty) {
        entity.rows.removeWhere((element) => (currentTime - element.time) > _MAX_STORAGE_TIME_SECONDS);
        // entity.rows.removeWhere((element) => ((currentTime - element.time) > _MAX_STORAGE_TIME_SECONDS) && element.isFinished);
      }
    }
  }

  @override
  delete(int bodyPart, {int start = 0, int end = -1}) {
    var entity = _findEntity(bodyPart);
    if(entity.rows.isEmpty) {
      return;
    }
    if(end == -1) {
      end = entity.rows.length - 1;
    }
    entity.rows.removeRange(start, end);
  }
}

class FootEntityImpl extends FootEntity {
  final FootRepositoryImpl _repositoryImpl;
  @override
  int bodyPart;
  @override
  List<FootRowImpl> rows = [];
  FootEntityImpl(this._repositoryImpl, this.bodyPart);
  @override
  List<int> get props => [bodyPart];

  @override
  Iterable<FootRow> get rowsFinished => rows
      .where((element) => element.isAllInitFinished);
}

class FootRowImpl extends FootRow {
  final FootRepositoryImpl _repositoryImpl;

  @override
  bool isMagToAIFinished = false;

  @override
  bool get isAllCalculateFinished => isMagToAIFinished;

  @override
  bool get isAllInitFinished => isAllCalculateFinished;

  List<int> raw;
  List<List<double>> rawToAI = List
      .generate(
          FootSensorPosition.numberOfFootSensor,
          (index) => [0,0,0],
      );
  _magToAI() async {
    List<List<double>> prediction = [];
    for(var sensor in sensorsData) {
      prediction.add(await AIModel.convertFootMagnetsToPressure(sensor.magX, sensor.magY, sensor.magZ));
    }
    rawToAI = prediction;
    isMagToAIFinished = true;
    _repositoryImpl._onNewRowFinishedController.sink.add(entity);
    _repositoryImpl._onNewRowFinishedControllerRow.sink.add(this);
  }
  _init() async {
    // await _magToAI();
  }
  FootRowImpl(this._repositoryImpl, this.entity, this.rowId, this.time, this.raw) {
    _init();
  }
  @override
  FootEntity entity;
  @override
  int rowId;
  @override
  int get bodyPart => entity.bodyPart;
  @override
  int get rowIndex {
    var row = entity.rows.indexed.where((element) => element.$2.rowId == rowId).firstOrNull;
    return (row == null) ? -1 : row.$1;
  }
  @override
  double time;
  @override
  double get accX => BytesConverter.byteArrayToInt16([raw[1], raw[2]]).toDouble();
  @override
  double get accY => BytesConverter.byteArrayToInt16([raw[3], raw[4]]).toDouble();
  @override
  double get accZ => BytesConverter.byteArrayToInt16([raw[5], raw[6]]).toDouble();
  @override
  double get gyroX => BytesConverter.byteArrayToInt16([raw[7], raw[8]]).toDouble();
  @override
  double get gyroY => BytesConverter.byteArrayToInt16([raw[9], raw[10]]).toDouble();
  @override
  double get gyroZ => BytesConverter.byteArrayToInt16([raw[11], raw[12]]).toDouble();
  @override
  double get magX => BytesConverter.byteArrayToInt16([raw[13], raw[14]]).toDouble();
  @override
  double get magY => BytesConverter.byteArrayToInt16([raw[15], raw[16]]).toDouble();
  @override
  double get magZ => BytesConverter.byteArrayToInt16([raw[17], raw[18]]).toDouble();
  @override
  double get pitch => BytesConverter.byteArrayToInt16([raw[19], raw[20]]).toDouble();
  @override
  double get roll => BytesConverter.byteArrayToInt16([raw[21], raw[22]]).toDouble();
  @override
  double get yaw => BytesConverter.byteArrayToInt16([raw[23], raw[24]]).toDouble();
  @override
  late List<FootSensorData> sensorsData = List.generate(
      FootSensorPosition.numberOfFootSensor,
      (index) => FootSensorDataImpl(_repositoryImpl, entity, this, index),
  );

  @override
  Point get sensorPressureCenter {
    return Point(
      sensorsData
          .indexed
          .map((e) => FootSensorPosition.getByBodyPart(entity.bodyPart)[e.$1].x * e.$2.pressure)
          .reduce((value, element) => value + element)
          / FootSensorPosition.numberOfFootSensor,
      sensorsData
          .indexed
          .map((e) => FootSensorPosition.getByBodyPart(entity.bodyPart)[e.$1].y * e.$2.pressure)
          .reduce((value, element) => value + element)
          / FootSensorPosition.numberOfFootSensor,
    );
  }
  @override
  double get sensorPressureAverage =>
      sensorsData
          .map((e) => e.pressure)
          .reduce((value, element) => value + element)
          / FootSensorPosition.numberOfFootSensor;
  @override
  Point get sensorTemperatureCenter {
    return Point(
      sensorsData
          .indexed
          .map((e) => FootSensorPosition.getByBodyPart(entity.bodyPart)[e.$1].x * e.$2.temperature)
          .reduce((value, element) => value + element)
          / FootSensorPosition.numberOfFootSensor,
      sensorsData
          .indexed
          .map((e) => FootSensorPosition.getByBodyPart(entity.bodyPart)[e.$1].y * e.$2.temperature)
          .reduce((value, element) => value + element)
          / FootSensorPosition.numberOfFootSensor,
    );
  }
  @override
  double get sensorTemperatureAverage =>
      sensorsData
          .map((e) => e.temperature)
          .reduce((value, element) => value + element)
          / FootSensorPosition.numberOfFootSensor;

  @override
  addSensor(FootSensorData footSensorData) {
    sensorsData.add(footSensorData);
  }
}

class FootSensorDataImpl extends FootSensorData {
  final FootRepositoryImpl _repositoryImpl;
  List<int> get raw => (row as FootRowImpl).raw;
  List<double> get rawToAI => (row as FootRowImpl).rawToAI[sensorIndex];
  FootSensorDataImpl(this._repositoryImpl, this.entity, this.row, this.sensorIndex);
  @override
  FootEntity entity;
  @override
  int get bodyPart => entity.bodyPart;
  @override
  FootRow row;
  @override
  int get rowId => row.rowId;
  @override
  int get rowIndex => row.rowIndex;
  @override
  int sensorIndex;
  @override
  double get magX => BytesConverter.byteArrayToUint16([
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 0) + (sensorIndex * 2) + 0],
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 0) + (sensorIndex * 2) + 1],
  ]).toDouble();
  @override
  double get magY => BytesConverter.byteArrayToUint16([
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 2) + (sensorIndex * 2) + 0],
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 2) + (sensorIndex * 2) + 1],
  ]).toDouble();
  @override
  double get magZ => BytesConverter.byteArrayToUint16([
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 4) + (sensorIndex * 2) + 0],
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 4) + (sensorIndex * 2) + 1],
  ]).toDouble();
  @override
  double get temperature => BytesConverter.byteArrayToUint8([
    raw[_SENSOR_RAW_START_INDEX + (FootSensorPosition.numberOfFootSensor * 6) + sensorIndex],
  ]).toDouble();
  @override
  double get shearForceX => rawToAI[0];
  @override
  double get shearForceY => rawToAI[1];
  @override
  double get shearForceTotal => sqrt(pow(shearForceX, 2) + pow(shearForceY, 2));
  @override
  double get shearForceRadians => atan2(shearForceY, shearForceX);
  @override
  double get pressure => rawToAI[2];
  @override
  Point<double> get position => FootSensorPosition.getByBodyPart(bodyPart)[sensorIndex];
}