// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: (json['grade'] as num).toInt(),
      letter: json['letter'] as String,
      studentCount: (json['studentCount'] as num).toInt(),
      averagePerformance: (json['averagePerformance'] as num).toDouble(),
      students: (json['students'] as List<dynamic>)
          .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      teacherId: json['teacherId'] as String,
    );

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade': instance.grade,
      'letter': instance.letter,
      'studentCount': instance.studentCount,
      'averagePerformance': instance.averagePerformance,
      'students': instance.students,
      'teacherId': instance.teacherId,
    };
