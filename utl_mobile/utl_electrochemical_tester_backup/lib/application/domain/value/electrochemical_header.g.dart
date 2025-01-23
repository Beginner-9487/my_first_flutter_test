// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrochemical_header.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElectrochemicalHeaderAdapter extends TypeAdapter<ElectrochemicalHeader> {
  @override
  final int typeId = 20;

  @override
  ElectrochemicalHeader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElectrochemicalHeader(
      dataName: fields[2] as String,
      deviceId: fields[3] as String,
      createdTime: fields[4] as int,
      temperature: fields[5] as int,
      parameters: fields[6] as ElectrochemicalParameters,
    );
  }

  @override
  void write(BinaryWriter writer, ElectrochemicalHeader obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj.dataName)
      ..writeByte(3)
      ..write(obj.deviceId)
      ..writeByte(4)
      ..write(obj.createdTime)
      ..writeByte(5)
      ..write(obj.temperature)
      ..writeByte(6)
      ..write(obj.parameters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElectrochemicalHeaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
