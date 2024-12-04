// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 0;

  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUser(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[3] as String,
      lastName: fields[2] as String,
      position: fields[6] as String?,
      company: fields[5] as String?,
      description: fields[8] as String?,
      imageUrl: fields[4] as String?,
      experience: fields[9] as String?,
      linkedinUrl: fields[10] as String?,
      sessionsDeliver: fields[7] as String?,
      degreeProgram: fields[11] as String?,
      yearOfGraduation: fields[12] as String?,
      instituteName: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.company)
      ..writeByte(6)
      ..write(obj.position)
      ..writeByte(7)
      ..write(obj.sessionsDeliver)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.experience)
      ..writeByte(10)
      ..write(obj.linkedinUrl)
      ..writeByte(11)
      ..write(obj.degreeProgram)
      ..writeByte(12)
      ..write(obj.yearOfGraduation)
      ..writeByte(13)
      ..write(obj.instituteName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
