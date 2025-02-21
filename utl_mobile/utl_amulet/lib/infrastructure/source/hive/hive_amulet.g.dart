// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_amulet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveAmuletEntityAdapter extends TypeAdapter<HiveAmuletEntity> {
  @override
  final int typeId = 1;

  @override
  HiveAmuletEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAmuletEntity(
      deviceId: fields[0] as String,
      time: fields[1] as DateTime,
      accX: fields[2] as int,
      accY: fields[3] as int,
      accZ: fields[4] as int,
      accTotal: fields[5] as int,
      magX: fields[6] as int,
      magY: fields[7] as int,
      magZ: fields[8] as int,
      magTotal: fields[9] as int,
      pitch: fields[10] as int,
      roll: fields[11] as int,
      yaw: fields[12] as int,
      pressure: fields[13] as double,
      temperature: fields[14] as int,
      posture: fields[15] as HiveAmuletPostureType,
      adc: fields[16] as int,
      battery: fields[17] as int,
      area: fields[18] as int,
      step: fields[19] as int,
      direction: fields[20] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAmuletEntity obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.accX)
      ..writeByte(3)
      ..write(obj.accY)
      ..writeByte(4)
      ..write(obj.accZ)
      ..writeByte(5)
      ..write(obj.accTotal)
      ..writeByte(6)
      ..write(obj.magX)
      ..writeByte(7)
      ..write(obj.magY)
      ..writeByte(8)
      ..write(obj.magZ)
      ..writeByte(9)
      ..write(obj.magTotal)
      ..writeByte(10)
      ..write(obj.pitch)
      ..writeByte(11)
      ..write(obj.roll)
      ..writeByte(12)
      ..write(obj.yaw)
      ..writeByte(13)
      ..write(obj.pressure)
      ..writeByte(14)
      ..write(obj.temperature)
      ..writeByte(15)
      ..write(obj.posture)
      ..writeByte(16)
      ..write(obj.adc)
      ..writeByte(17)
      ..write(obj.battery)
      ..writeByte(18)
      ..write(obj.area)
      ..writeByte(19)
      ..write(obj.step)
      ..writeByte(20)
      ..write(obj.direction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAmuletEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveAmuletPostureTypeAdapter extends TypeAdapter<HiveAmuletPostureType> {
  @override
  final int typeId = 0;

  @override
  HiveAmuletPostureType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HiveAmuletPostureType.init;
      case 1:
        return HiveAmuletPostureType.seating;
      case 2:
        return HiveAmuletPostureType.standing;
      case 3:
        return HiveAmuletPostureType.supine;
      case 4:
        return HiveAmuletPostureType.rightLateralDecubitus;
      case 5:
        return HiveAmuletPostureType.leftLateralDecubitus;
      case 6:
        return HiveAmuletPostureType.prone;
      case 7:
        return HiveAmuletPostureType.falling;
      case 8:
        return HiveAmuletPostureType.walking;
      default:
        return HiveAmuletPostureType.init;
    }
  }

  @override
  void write(BinaryWriter writer, HiveAmuletPostureType obj) {
    switch (obj) {
      case HiveAmuletPostureType.init:
        writer.writeByte(0);
        break;
      case HiveAmuletPostureType.seating:
        writer.writeByte(1);
        break;
      case HiveAmuletPostureType.standing:
        writer.writeByte(2);
        break;
      case HiveAmuletPostureType.supine:
        writer.writeByte(3);
        break;
      case HiveAmuletPostureType.rightLateralDecubitus:
        writer.writeByte(4);
        break;
      case HiveAmuletPostureType.leftLateralDecubitus:
        writer.writeByte(5);
        break;
      case HiveAmuletPostureType.prone:
        writer.writeByte(6);
        break;
      case HiveAmuletPostureType.falling:
        writer.writeByte(7);
        break;
      case HiveAmuletPostureType.walking:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAmuletPostureTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
