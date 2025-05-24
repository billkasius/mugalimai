// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentHistoryModel _$StudentHistoryModelFromJson(Map<String, dynamic> json) =>
    StudentHistoryModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      subject: json['subject'] as String,
      homeworkTitle: json['homeworkTitle'] as String,
      grade: (json['grade'] as num).toDouble(),
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$StudentHistoryModelToJson(
        StudentHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'subject': instance.subject,
      'homeworkTitle': instance.homeworkTitle,
      'grade': instance.grade,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
      'comment': instance.comment,
    };

WeeklyPerformance _$WeeklyPerformanceFromJson(Map<String, dynamic> json) =>
    WeeklyPerformance(
      week: json['week'] as String,
      averageGrade: (json['averageGrade'] as num).toDouble(),
      homeworksCompleted: (json['homeworksCompleted'] as num).toInt(),
      totalHomeworks: (json['totalHomeworks'] as num).toInt(),
    );

Map<String, dynamic> _$WeeklyPerformanceToJson(WeeklyPerformance instance) =>
    <String, dynamic>{
      'week': instance.week,
      'averageGrade': instance.averageGrade,
      'homeworksCompleted': instance.homeworksCompleted,
      'totalHomeworks': instance.totalHomeworks,
    };

HomeworkHistoryItem _$HomeworkHistoryItemFromJson(Map<String, dynamic> json) =>
    HomeworkHistoryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      grade: (json['grade'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      mistakes:
          (json['mistakes'] as List<dynamic>).map((e) => e as String).toList(),
      teacherComment: json['teacherComment'] as String?,
    );

Map<String, dynamic> _$HomeworkHistoryItemToJson(
        HomeworkHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'grade': instance.grade,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'mistakes': instance.mistakes,
      'teacherComment': instance.teacherComment,
    };

SubjectHistory _$SubjectHistoryFromJson(Map<String, dynamic> json) =>
    SubjectHistory(
      subjectName: json['subjectName'] as String,
      homeworks: (json['homeworks'] as List<dynamic>)
          .map((e) => HomeworkHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageGrade: (json['averageGrade'] as num).toDouble(),
    );

Map<String, dynamic> _$SubjectHistoryToJson(SubjectHistory instance) =>
    <String, dynamic>{
      'subjectName': instance.subjectName,
      'homeworks': instance.homeworks,
      'averageGrade': instance.averageGrade,
    };
