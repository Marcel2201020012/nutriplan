// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_historis.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataHistorisAdapter extends TypeAdapter<DataHistoris> {
  @override
  final int typeId = 0;

  @override
  DataHistoris read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataHistoris(
      daftarMakanan: (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      totalKalori: fields[1] as double,
      kalori: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DataHistoris obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.daftarMakanan)
      ..writeByte(1)
      ..write(obj.totalKalori)
      ..writeByte(2)
      ..write(obj.kalori);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataHistorisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
