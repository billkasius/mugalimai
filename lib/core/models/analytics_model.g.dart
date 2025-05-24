// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProgress _$StudentProgressFromJson(Map<String, dynamic> json) =>
    StudentProgress(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      isImprovement: json['isImprovement'] as bool,
      subject: json['subject'] as String,
    );

Map<String, dynamic> _$StudentProgressToJson(StudentProgress instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'progressPercentage': instance.progressPercentage,
      'isImprovement': instance.isImprovement,
      'subject': instance.subject,
    };

ClassPerformance _$ClassPerformanceFromJson(Map<String, dynamic> json) =>
    ClassPerformance(
      classId: json['classId'] as String,
      className: json['className'] as String,
      performanceChange: (json['performanceChange'] as num).toDouble(),
      isImprovement: json['isImprovement'] as bool,
      totalStudents: (json['totalStudents'] as num).toInt(),
    );

Map<String, dynamic> _$ClassPerformanceToJson(ClassPerformance instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'performanceChange': instance.performanceChange,
      'isImprovement': instance.isImprovement,
      'totalStudents': instance.totalStudents,
    };

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalStudents: (json['totalStudents'] as num).toInt(),
      totalClasses: (json['totalClasses'] as num).toInt(),
      homeworksChecked: (json['homeworksChecked'] as num).toInt(),
      testsGenerated: (json['testsGenerated'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'totalStudents': instance.totalStudents,
      'totalClasses': instance.totalClasses,
      'homeworksChecked': instance.homeworksChecked,
      'testsGenerated': instance.testsGenerated,
    };
