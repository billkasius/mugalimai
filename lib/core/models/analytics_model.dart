import 'package:json_annotation/json_annotation.dart';

part 'analytics_model.g.dart';

@JsonSerializable()
class StudentProgress {
  final String studentId;
  final String studentName;
  final double progressPercentage;
  final bool isImprovement;
  final String subject;

  const StudentProgress({
    required this.studentId,
    required this.studentName,
    required this.progressPercentage,
    required this.isImprovement,
    required this.subject,
  });

  factory StudentProgress.fromJson(Map<String, dynamic> json) =>
      _$StudentProgressFromJson(json);

  Map<String, dynamic> toJson() => _$StudentProgressToJson(this);
}

@JsonSerializable()
class ClassPerformance {
  final String classId;
  final String className;
  final double performanceChange;
  final bool isImprovement;
  final int totalStudents;

  const ClassPerformance({
    required this.classId,
    required this.className,
    required this.performanceChange,
    required this.isImprovement,
    required this.totalStudents,
  });

  factory ClassPerformance.fromJson(Map<String, dynamic> json) =>
      _$ClassPerformanceFromJson(json);

  Map<String, dynamic> toJson() => _$ClassPerformanceToJson(this);
}

@JsonSerializable()
class DashboardStats {
  final int totalStudents;
  final int totalClasses;
  final int homeworksChecked;
  final int testsGenerated;

  const DashboardStats({
    required this.totalStudents,
    required this.totalClasses,
    required this.homeworksChecked,
    required this.testsGenerated,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}
