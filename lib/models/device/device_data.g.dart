// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceDataAdapter extends TypeAdapter<DeviceData> {
  @override
  DeviceData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceData(
      fields[0] as String,
      fields[1] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.config)
      ..writeByte(4)
      ..write(obj.ip)
      ..writeByte(5)
      ..write(obj.mdns);
  }
}
