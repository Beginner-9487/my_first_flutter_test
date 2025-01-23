// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrochemical_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElectrochemicalTypeAdapter extends TypeAdapter<ElectrochemicalType> {
  @override
  final int typeId = 40;

  @override
  ElectrochemicalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ElectrochemicalType.ca;
      case 1:
        return ElectrochemicalType.cv;
      case 2:
        return ElectrochemicalType.dpv;
      default:
        return ElectrochemicalType.ca;
    }
  }

  @override
  void write(BinaryWriter writer, ElectrochemicalType obj) {
    switch (obj) {
      case ElectrochemicalType.ca:
        writer.writeByte(0);
        break;
      case ElectrochemicalType.cv:
        writer.writeByte(1);
        break;
      case ElectrochemicalType.dpv:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElectrochemicalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
