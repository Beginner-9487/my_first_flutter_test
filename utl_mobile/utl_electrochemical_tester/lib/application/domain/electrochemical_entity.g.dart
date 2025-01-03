// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrochemical_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElectrochemicalEntityAdapter extends TypeAdapter<ElectrochemicalEntity> {
  @override
  final int typeId = 0;

  @override
  ElectrochemicalEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElectrochemicalEntity(
      id: fields[0] as int,
      dataName: fields[2] as String,
      deviceId: fields[3] as String,
      createdTime: fields[4] as int,
      temperature: fields[5] as int,
      parameters: fields[6] as ElectrochemicalParameters,
      data: (fields[1] as List).cast<ElectrochemicalData>(),
    );
  }

  @override
  void write(BinaryWriter writer, ElectrochemicalEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data)
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
      other is ElectrochemicalEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
