// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_electrochemical.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveElectrochemicalEntityAdapter
    extends TypeAdapter<HiveElectrochemicalEntity> {
  @override
  final int typeId = 0;

  @override
  HiveElectrochemicalEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveElectrochemicalEntity(
      electrochemicalHeader: fields[0] as HiveElectrochemicalHeader,
      data: (fields[1] as List).cast<HiveElectrochemicalData>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveElectrochemicalEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.electrochemicalHeader)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveElectrochemicalEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveElectrochemicalDataAdapter
    extends TypeAdapter<HiveElectrochemicalData> {
  @override
  final int typeId = 1;

  @override
  HiveElectrochemicalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveElectrochemicalData(
      index: fields[0] as int,
      time: fields[1] as int,
      voltage: fields[2] as int,
      current: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveElectrochemicalData obj) {
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
      other is HiveElectrochemicalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveElectrochemicalHeaderAdapter
    extends TypeAdapter<HiveElectrochemicalHeader> {
  @override
  final int typeId = 2;

  @override
  HiveElectrochemicalHeader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveElectrochemicalHeader(
      dataName: fields[0] as String,
      deviceId: fields[1] as String,
      createdTime: fields[2] as DateTime,
      temperature: fields[3] as int,
      parameters: fields[4] as HiveElectrochemicalParameters,
    );
  }

  @override
  void write(BinaryWriter writer, HiveElectrochemicalHeader obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dataName)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.createdTime)
      ..writeByte(3)
      ..write(obj.temperature)
      ..writeByte(4)
      ..write(obj.parameters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveElectrochemicalHeaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveCaElectrochemicalParametersAdapter
    extends TypeAdapter<HiveCaElectrochemicalParameters> {
  @override
  final int typeId = 4;

  @override
  HiveCaElectrochemicalParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCaElectrochemicalParameters(
      eDc: fields[1] as int,
      tInterval: fields[2] as int,
      tRun: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCaElectrochemicalParameters obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.eDc)
      ..writeByte(2)
      ..write(obj.tInterval)
      ..writeByte(3)
      ..write(obj.tRun)
      ..writeByte(0)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCaElectrochemicalParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveCvElectrochemicalParametersAdapter
    extends TypeAdapter<HiveCvElectrochemicalParameters> {
  @override
  final int typeId = 5;

  @override
  HiveCvElectrochemicalParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCvElectrochemicalParameters(
      eBegin: fields[1] as int,
      eVertex1: fields[2] as int,
      eVertex2: fields[3] as int,
      eStep: fields[4] as int,
      scanRate: fields[5] as int,
      numberOfScans: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCvElectrochemicalParameters obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.eBegin)
      ..writeByte(2)
      ..write(obj.eVertex1)
      ..writeByte(3)
      ..write(obj.eVertex2)
      ..writeByte(4)
      ..write(obj.eStep)
      ..writeByte(5)
      ..write(obj.scanRate)
      ..writeByte(6)
      ..write(obj.numberOfScans)
      ..writeByte(0)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCvElectrochemicalParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveDpvElectrochemicalParametersAdapter
    extends TypeAdapter<HiveDpvElectrochemicalParameters> {
  @override
  final int typeId = 6;

  @override
  HiveDpvElectrochemicalParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDpvElectrochemicalParameters(
      eBegin: fields[1] as int,
      eEnd: fields[2] as int,
      eStep: fields[3] as int,
      ePulse: fields[4] as int,
      tPulse: fields[5] as int,
      scanRate: fields[6] as int,
      inversionOption:
          fields[7] as HiveDpvElectrochemicalParametersInversionOption,
    );
  }

  @override
  void write(BinaryWriter writer, HiveDpvElectrochemicalParameters obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.eBegin)
      ..writeByte(2)
      ..write(obj.eEnd)
      ..writeByte(3)
      ..write(obj.eStep)
      ..writeByte(4)
      ..write(obj.ePulse)
      ..writeByte(5)
      ..write(obj.tPulse)
      ..writeByte(6)
      ..write(obj.scanRate)
      ..writeByte(7)
      ..write(obj.inversionOption)
      ..writeByte(0)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDpvElectrochemicalParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveElectrochemicalTypeAdapter
    extends TypeAdapter<HiveElectrochemicalType> {
  @override
  final int typeId = 3;

  @override
  HiveElectrochemicalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HiveElectrochemicalType.ca;
      case 1:
        return HiveElectrochemicalType.cv;
      case 2:
        return HiveElectrochemicalType.dpv;
      default:
        return HiveElectrochemicalType.ca;
    }
  }

  @override
  void write(BinaryWriter writer, HiveElectrochemicalType obj) {
    switch (obj) {
      case HiveElectrochemicalType.ca:
        writer.writeByte(0);
        break;
      case HiveElectrochemicalType.cv:
        writer.writeByte(1);
        break;
      case HiveElectrochemicalType.dpv:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveElectrochemicalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveDpvElectrochemicalParametersInversionOptionAdapter
    extends TypeAdapter<HiveDpvElectrochemicalParametersInversionOption> {
  @override
  final int typeId = 7;

  @override
  HiveDpvElectrochemicalParametersInversionOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HiveDpvElectrochemicalParametersInversionOption.none;
      case 1:
        return HiveDpvElectrochemicalParametersInversionOption.both;
      case 2:
        return HiveDpvElectrochemicalParametersInversionOption.cathodic;
      case 3:
        return HiveDpvElectrochemicalParametersInversionOption.anodic;
      default:
        return HiveDpvElectrochemicalParametersInversionOption.none;
    }
  }

  @override
  void write(BinaryWriter writer,
      HiveDpvElectrochemicalParametersInversionOption obj) {
    switch (obj) {
      case HiveDpvElectrochemicalParametersInversionOption.none:
        writer.writeByte(0);
        break;
      case HiveDpvElectrochemicalParametersInversionOption.both:
        writer.writeByte(1);
        break;
      case HiveDpvElectrochemicalParametersInversionOption.cathodic:
        writer.writeByte(2);
        break;
      case HiveDpvElectrochemicalParametersInversionOption.anodic:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDpvElectrochemicalParametersInversionOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
