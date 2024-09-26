import 'dart:async';

import 'package:flutter_ble/application/domain/ble_repository.dart';
import 'package:flutter_util/cracking_code/bytes_converter.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_repository.dart';
import 'package:utl_mackay_irb/application/domain/mackay_irb_type_impl.dart';

MackayIRBType _type_null = NullMackayIRBType();
MackayIRBType _type_temperature = NullMackayIRBType();
List<MackayIRBType> _types = [
  CortisolMackayIRBType(),
  LactateMackayIRBType(),
  _type_temperature,
  DPVMackayIRBType(),
];

MackayIRBType _rawToType(List<int> raw) {
  int id = BytesConverter.byteArrayToInt8(
    [
      raw[0],
    ],
  );
  for(var type in _types)
  {
    if(type.id == id)
      {
        return type;
      }
  }
  return _type_null;
}

int _rawToIndex(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[1],
      raw[2],
    ],
  );
}

int _rawToNumberOfData(List<int> raw) {
  return BytesConverter.byteArrayToInt16(
    [
      raw[3],
      raw[4],
    ],
  );
}

double _rawToVoltage(List<int> raw) {
  return BytesConverter.byteArrayToFloat(
    [
      raw[5],
      raw[6],
      raw[7],
      raw[8],
    ],
  );
}

double _rawToCurrent(List<int> raw) {
  return BytesConverter.byteArrayToFloat(
    [
      raw[9],
      raw[10],
      raw[11],
      raw[12],
    ],
  );
}

double _rawToTemperature(List<int> raw) {
  return BytesConverter.byteArrayToFloat(
    [
      raw[1],
      raw[2],
      raw[3],
      raw[4],
    ],
  );
}

MackayIRBEntityImpl _nullEntity = MackayIRBEntityImpl(
  id: 0,
  data_name: "",
  type: _type_null,
  time: DateTime.now(),
  number_of_data: 0,
  device: null,
  temperature: 0.0,
);

MackayIRBRowImpl _null_row = MackayIRBRowImpl(
    entity_id: 0,
    index: 0,
    voltage: 0,
    current: 0,
    time: DateTime.now(),
);

class _BufferBLEPacket {
  String name;
  BLEDevice device;
  List<int> raw;
  _BufferBLEPacket({
      required this.name,
      required this.device,
      required this.raw,
  });
}

class MackayIRBRepositoryImpl extends MackayIRBRepository {
  static MackayIRBRepositoryImpl? _instance;
  static MackayIRBRepositoryImpl getInstance() {
    _instance ??= MackayIRBRepositoryImpl._();
    return _instance!;
  }

  _add_new_data() async {
    _BufferBLEPacket? buffer = _bufferBLEPacket.firstOrNull;
    if(buffer == null) {
      return;
    }
    _bufferBLEPacket.removeAt(0);

    MackayIRBType type = _rawToType(buffer.raw);
    if(type == _type_temperature) {
      _temperature_buffer = _rawToTemperature(buffer.raw);
    }
    else if(type != _type_null)
    {
      DateTime time = DateTime.now();
      int number_of_data = _rawToNumberOfData(buffer.raw);
      Iterable<MackayIRBEntityImpl> type_entities = unfinishedEntities
          .where((element) => element.device == buffer.device)
          .where((entity) => entity.type == type);
      late MackayIRBEntityImpl entity;
      if(
      type_entities.isEmpty
      ) {
        entity = MackayIRBEntityImpl(
          id: _nextId,
          data_name: buffer.name,
          type: type,
          time: time,
          number_of_data: number_of_data,
          device: buffer.device,
          temperature: _temperature_buffer,
        );
        entities.add(entity);
        _onCreateController.sink.add(entity);
      } else {
        entity = type_entities.last;
      }
      int index = _rawToIndex(buffer.raw);
      MackayIRBRowImpl row = MackayIRBRowImpl(
        entity_id: entities.last.id,
        index: index,
        voltage: _rawToVoltage(buffer.raw),
        current: _rawToCurrent(buffer.raw),
        // TODO: 目前預設 time interval 都是 0.1s
        time: entity.time.add(
            (entity.rows.isEmpty) ?
            const Duration() :
            Duration(milliseconds: 100 * index)
        ),
      );
      entity.add(row);
      _onAddController.sink.add(row);
      if(index >= entity.number_of_data - 1) {
        _finish_handler(entity);
      }
    }
  }

  _setTimer() {
    Timer(const Duration(milliseconds: 10), () async {
      await _add_new_data();
      _setTimer();
    });
  }

  MackayIRBRepositoryImpl._() {
    _setTimer();
  }

  @override
  List<MackayIRBEntityImpl> entities = [];
  @override
  Iterable<MackayIRBEntityImpl> get finishedEntities => entities
      .where((entity) => entity.finished);
  @override
  Iterable<MackayIRBEntityImpl> get unfinishedEntities => entities
      .where((entity) => !entity.finished);

  int _currentId = 0;

  int get _nextId {
    return _currentId++;
  }

  double _temperature_buffer = 0.0;

  final List<_BufferBLEPacket> _bufferBLEPacket = [];
  add_new_data({
    required String name,
    required BLEDevice device,
    required List<int> raw,
  }) {
    _bufferBLEPacket.add(_BufferBLEPacket(
      name: name,
      device: device,
      raw: raw,
    ));
  }

  _delete_old_data() {
    DateTime current_time = DateTime.now();
    int current_length = entities.length;
    for(int i=current_length-1; i>=0; i--) {
      MackayIRBEntityImpl current_entity = entities[i];
      if(current_entity.rows.isNotEmpty && current_time.difference(current_entity.rows.last.time).inHours >= 2) {
        entities.removeAt(i);
      }
    }
  }

  _finish_handler(MackayIRBEntityImpl entity) {
    entity.finish();
    _delete_old_data();
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

String _get_datetime_format(DateTime time)
{
  return
    "${time.year}"
    "-${time.month.toString().padLeft(2, '0')}"
    "-${time.day.toString().padLeft(2, '0')}"
    " ${time.hour.toString().padLeft(2, '0')}"
    ":${time.minute.toString().padLeft(2, '0')}"
    ":${time.second.toString().padLeft(2, '0')}"
    ".${time.millisecond.toString().padLeft(3, '0')}"
    "${time.microsecond.toString().padLeft(3, '0')}"
  ;
}

String _get_datetime_format_simple(DateTime time)
{
  return
    "${time.year}"
        "-${time.month.toString().padLeft(2, '0')}"
        "-${time.day.toString().padLeft(2, '0')}"
        " ${time.hour.toString().padLeft(2, '0')}"
        ":${time.minute.toString().padLeft(2, '0')}"
        ":${time.second.toString().padLeft(2, '0')}"
  ;
}

String _get_datetime_format_for_filename(DateTime time)
{
  return
    "${time.year}"
        "-${time.month.toString().padLeft(2, '0')}"
        "-${time.day.toString().padLeft(2, '0')}"
        "-${time.hour.toString().padLeft(2, '0')}"
        "-${time.minute.toString().padLeft(2, '0')}"
        "-${time.second.toString().padLeft(2, '0')}"
  ;
}

String _get_duration_format(Duration duration)
{
  return
    "${(duration.inSeconds).toString().padLeft(2, '0')}"
        ".${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}"
        "${(duration.inMicroseconds % 1000).toString().padLeft(3, '0')}"
  ;
}

String _get_duration_format_for_filename(Duration duration)
{
  return
    "${(duration.inSeconds).toString().padLeft(2, '0')}"
        "-${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}"
        "${(duration.inMicroseconds % 1000).toString().padLeft(3, '0')}"
  ;
}

class MackayIRBEntityImpl extends MackayIRBEntity {
  final MackayIRBRepositoryImpl repository = MackayIRBRepositoryImpl
      .getInstance();
  @override
  int id;
  @override
  List<MackayIRBRowImpl> rows = [];

  @override
  String data_name;

  @override
  String get device_name => (device != null) ? device!.name : "";

  @override
  String get type_name => type.name;

  @override
  String get created_time_format => _get_datetime_format(time);

  @override
  String get created_time_format_simple => _get_datetime_format_simple(time);

  @override
  String get created_time_format_for_filename => _get_datetime_format_for_filename(time);

  @override
  String get finished_time_format =>
      (rows.lastOrNull != null) ? rows.last.created_time_format : "";

  @override
  String get finished_time_format_for_filename =>
      (rows.lastOrNull != null) ? rows.last.created_time_format_for_file : "";

  @override
  MackayIRBType type;
  @override
  int number_of_data;
  @override
  bool finished = false;

  BLEDevice? device;

  @override
  double temperature;

  DateTime time;

  @override
  int get created_time => time.microsecondsSinceEpoch;

  @override
  int get finished_time =>
      (rows.lastOrNull != null) ? rows.last.created_time : 0;

  MackayIRBEntityImpl({
    required this.id,
    required this.data_name,
    required this.type,
    required this.time,
    required this.number_of_data,
    required this.device,
    required this.temperature,
  });

  add(MackayIRBRowImpl row) {
    if (finished) {
      return;
    }
    rows.add(row);
    repository._onAddController.sink.add(row);
  }

  finish() {
    finished = true;
    repository._onFinishController.sink.add(this);
  }

  @override
  MackayIRBRow get_row_by_time(double time)
  {
    if(rows.isEmpty) {
      return _null_row;
    }
    MackayIRBRowImpl first = rows.first;
    for(var row in rows.skip(1)) {
      if(row.time.difference(first.time).inMicroseconds >= time * 1000000.0) {
        return row;
      }
    }
    return rows.last;
  }

  @override
  StreamSubscription<MackayIRBRow> onAdded(void Function(MackayIRBRow row) doSomething) {
    return repository._onAddController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<MackayIRBEntity> onCreated(void Function(MackayIRBEntity entity) doSomething) {
    return repository._onCreateController.stream.listen(doSomething);
  }

  @override
  StreamSubscription<MackayIRBEntity> onFinished(void Function(MackayIRBEntity entity) doSomething) {
    return repository._onFinishController.stream.listen(doSomething);
  }
}

class MackayIRBRowImpl extends MackayIRBRow {
  final MackayIRBRepositoryImpl repository = MackayIRBRepositoryImpl.getInstance();

  int entity_id;

  @override
  MackayIRBEntityImpl get entity
  {
    MackayIRBEntityImpl? entity = repository.entities.where((element) => element.id == entity_id).firstOrNull;
    entity ??= _nullEntity;
    return entity;
  }

  @override
  int index;
  @override
  double current;
  @override
  double voltage;

  DateTime time;

  MackayIRBRowImpl({
    required this.entity_id,
    required this.index,
    required this.voltage,
    required this.current,
    required this.time,
  });

  @override
  int get created_time => time.microsecondsSinceEpoch;

  @override
  int get created_time_related_to_entity => time.difference(entity.time).inMicroseconds;

  @override
  double get created_time_related_to_entity_seconds => created_time_related_to_entity / 1000000;

  @override
  String get created_time_format => _get_datetime_format(time);

  @override
  String get created_time_format_for_file => _get_datetime_format_for_filename(time);

  @override
  String get created_time_related_to_entity_format => _get_duration_format(time.difference(entity.time));

  @override
  String get created_time_related_to_entity_format_for_file => _get_duration_format_for_filename(time.difference(entity.time));
}