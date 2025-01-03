// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrochemical_parameters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaElectrochemicalParametersAdapter
    extends TypeAdapter<CaElectrochemicalParameters> {
  @override
  final int typeId = 30;

  @override
  CaElectrochemicalParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaElectrochemicalParameters(
      eDc: fields[0] as int,
      tInterval: fields[1] as int,
      tRun: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CaElectrochemicalParameters obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.eDc)
      ..writeByte(1)
      ..write(obj.tInterval)
      ..writeByte(2)
      ..write(obj.tRun);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaElectrochemicalParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CvElectrochemicalParametersAdapter
    extends TypeAdapter<CvElectrochemicalParameters> {
  @override
  final int typeId = 31;

  @override
  CvElectrochemicalParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CvElectrochemicalParameters(
      eBegin: fields[0] as int,
      eVertex1: fields[1] as int,
      eVertex2: fields[2] as int,
      eStep: fields[3] as int,
      scanRate: fields[4] as int,
      numberOfScans: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CvElectrochemicalParameters obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.eBegin)
      ..writeByte(1)
      ..write(obj.eVertex1)
      ..writeByte(2)
      ..write(obj.eVertex2)
      ..writeByte(3)
      ..write(obj.eStep)
      ..writeByte(4)
      ..write(obj.scanRate)
      ..writeByte(5)
      ..write(obj.numberOfScans);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CvElectrochemicalParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DpvElectrochemicalParametersAdapter
    extends TypeAdapter<DpvElectrochemicalParameters> {
  @override
  final int typeId = 32;

  @override
  DpvElectrochemicalParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DpvElectrochemicalParameters(
      eBegin: fields[0] as int,
      eEnd: fields[1] as int,
      eStep: fields[2] as int,
      ePulse: fields[3] as int,
      tPulse: fields[4] as int,
      scanRate: fields[5] as int,
      inversionOption: fields[6] as InversionOption,
    );
  }

  @override
  void write(BinaryWriter writer, DpvElectrochemicalParameters obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.eBegin)
      ..writeByte(1)
      ..write(obj.eEnd)
      ..writeByte(2)
      ..write(obj.eStep)
      ..writeByte(3)
      ..write(obj.ePulse)
      ..writeByte(4)
      ..write(obj.tPulse)
      ..writeByte(5)
      ..write(obj.scanRate)
      ..writeByte(6)
      ..write(obj.inversionOption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DpvElectrochemicalParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InversionOptionAdapter extends TypeAdapter<InversionOption> {
  @override
  final int typeId = 33;

  @override
  InversionOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InversionOption.none;
      case 1:
        return InversionOption.both;
      case 2:
        return InversionOption.cathodic;
      case 3:
        return InversionOption.anodic;
      default:
        return InversionOption.none;
    }
  }

  @override
  void write(BinaryWriter writer, InversionOption obj) {
    switch (obj) {
      case InversionOption.none:
        writer.writeByte(0);
        break;
      case InversionOption.both:
        writer.writeByte(1);
        break;
      case InversionOption.cathodic:
        writer.writeByte(2);
        break;
      case InversionOption.anodic:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InversionOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
