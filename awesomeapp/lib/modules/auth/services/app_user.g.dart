// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

// class AppUserAdapter extends TypeAdapter<AppUser> {
//   @override
//   final int typeId = 0;
//
//   @override
//   AppUser read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     final appUser = AppUser(
//       id: fields[0] as String,
//       name: fields[1] as String,
//       email: fields[3] as String,
//       lastName: fields[2] as String,
//       position: fields[6] as String?,
//       company: fields[5] as String?,
//       description: fields[8] as String?,
//       imageUrl: fields[4] as String?,
//       yearsOfExperience: fields[9] as String?,
//       linkedInUrl: fields[10] as String?,
//       sessionsDeliver: fields[7] as String?,
//       degreeProgram: fields[11] as String?,
//       yearOfGraduation: fields[12] as String?,
//       instituteName: fields[13] as String?,
//       accessToken: fields[14] as String?,
//       refreshToken: fields[15] as String?,
//     );
//
//     return appUser;
//   }
//
//   @override
//   void write(BinaryWriter writer, AppUser obj) {
//     writer
//       ..writeByte(16) // total fields from 0 to 15
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.name)
//       ..writeByte(2)
//       ..write(obj.lastName)
//       ..writeByte(3)
//       ..write(obj.email)
//       ..writeByte(4)
//       ..write(obj.imageUrl)
//       ..writeByte(5)
//       ..write(obj.company)
//       ..writeByte(6)
//       ..write(obj.position)
//       ..writeByte(7)
//       ..write(obj.sessionsDeliver)
//       ..writeByte(8)
//       ..write(obj.description)
//       ..writeByte(9)
//       ..write(obj.yearsOfExperience)
//       ..writeByte(10)
//       ..write(obj.linkedInUrl)
//       ..writeByte(11)
//       ..write(obj.degreeProgram)
//       ..writeByte(12)
//       ..write(obj.yearOfGraduation)
//       ..writeByte(13)
//       ..write(obj.instituteName)
//       ..writeByte(14)
//       ..write(obj.accessToken)
//       ..writeByte(15)
//       ..write(obj.refreshToken);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AppUserAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }

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
      lastName: fields[2] as String,
      email: fields[3] as String,
      imageUrl: fields[4] as String?,
      company: fields[5] as String?,
      position: fields[6] as String?,
      sessionsDeliver: fields[7] as String?,
      description: fields[8] as String?,
      yearsOfExperience: fields[9] as String?,
      linkedInUrl: fields[10] as String?,
      degreeProgram: fields[11] as String?,
      yearOfGraduation: fields[12] as String?,
      instituteName: fields[13] as String?,
      accessToken: fields[14] as String?,
      refreshToken: fields[15] as String?,
      userType: fields[16] as String?,
      isSpeaker: fields[17] as bool?,
      conferenceId: (fields[18] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(19) // number of fields written
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.lastName)
      ..writeByte(3)..write(obj.email)
      ..writeByte(4)..write(obj.imageUrl)
      ..writeByte(5)..write(obj.company)
      ..writeByte(6)..write(obj.position)
      ..writeByte(7)..write(obj.sessionsDeliver)
      ..writeByte(8)..write(obj.description)
      ..writeByte(9)..write(obj.yearsOfExperience)
      ..writeByte(10)..write(obj.linkedInUrl)
      ..writeByte(11)..write(obj.degreeProgram)
      ..writeByte(12)..write(obj.yearOfGraduation)
      ..writeByte(13)..write(obj.instituteName)
      ..writeByte(14)..write(obj.accessToken)
      ..writeByte(15)..write(obj.refreshToken)
      ..writeByte(16)..write(obj.userType)
      ..writeByte(17)..write(obj.isSpeaker)
      ..writeByte(18)..write(obj.conferenceId);
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
