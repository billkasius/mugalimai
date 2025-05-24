// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      classId: json['classId'] as String,
      subjects:
          (json['subjects'] as List<dynamic>).map((e) => e as String).toList(),
      averageGrades: (json['averageGrades'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      photoUrl: json['photoUrl'] as String?,
      birthDate: StudentModel._dateTimeFromJson(json['birthDate'] as String?),
    );

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'classId': instance.classId,
      'subjects': instance.subjects,
      'averageGrades': instance.averageGrades,
      'photoUrl': instance.photoUrl,
      'birthDate': StudentModel._dateTimeToJson(instance.birthDate),
    };
