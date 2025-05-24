// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      schoolId: json['schoolId'] as String,
      classIds:
          (json['classIds'] as List<dynamic>).map((e) => e as String).toList(),
      subjectIds: (json['subjectIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAdmin: json['isAdmin'] as bool? ?? false,
      createdAt: TeacherModel._dateTimeFromJson(json['createdAt'] as String),
    );

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'schoolId': instance.schoolId,
      'classIds': instance.classIds,
      'subjectIds': instance.subjectIds,
      'isAdmin': instance.isAdmin,
      'createdAt': TeacherModel._dateTimeToJson(instance.createdAt),
    };
