// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrochemical_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElectrochemicalDataAdapter extends TypeAdapter<ElectrochemicalData> {
  @override
  final int typeId = 10;

  @override
  ElectrochemicalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElectrochemicalData(
      index: fields[0] as int,
      time: fields[1] as int,
      voltage: fields[2] as int,
      current: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ElectrochemicalData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.voltage)
      ..writeByte(3)
      ..write(obj.current);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElectrochemicalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
