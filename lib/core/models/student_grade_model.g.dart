// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_grade_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentGradeModel _$StudentGradeModelFromJson(Map<String, dynamic> json) =>
    StudentGradeModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      subjectId: json['subjectId'] as String,
      grade: (json['grade'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt:
          StudentGradeModel._dateTimeFromJson(json['createdAt'] as String),
      teacherId: json['teacherId'] as String,
    );

Map<String, dynamic> _$StudentGradeModelToJson(StudentGradeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'subjectId': instance.subjectId,
      'grade': instance.grade,
      'comment': instance.comment,
      'createdAt': StudentGradeModel._dateTimeToJson(instance.createdAt),
      'teacherId': instance.teacherId,
    };
