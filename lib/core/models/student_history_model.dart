// lib/core/models/student_history_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'student_history_model.g.dart';

@JsonSerializable()
class StudentHistoryModel {
  final String id;
  final String studentId;
  final String subject;
  final String homeworkTitle;
  final double grade;
  final String status;
  final DateTime date;
  final String? comment;

  const StudentHistoryModel({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.homeworkTitle,
    required this.grade,
    required this.status,
    required this.date,
    this.comment,
  });

  factory StudentHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$StudentHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentHistoryModelToJson(this);
}

@JsonSerializable()
class WeeklyPerformance {
  final String week;
  final double averageGrade;
  final int homeworksCompleted;
  final int totalHomeworks;

  const WeeklyPerformance({
    required this.week,
    required this.averageGrade,
    required this.homeworksCompleted,
    required this.totalHomeworks,
  });

  double get completionRate => homeworksCompleted / totalHomeworks;

  factory WeeklyPerformance.fromJson(Map<String, dynamic> json) =>
      _$WeeklyPerformanceFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyPerformanceToJson(this);
}

@JsonSerializable()
class HomeworkHistoryItem {
  final String id;
  final String title;
  final double grade;
  final DateTime date;
  final String status; // 'excellent', 'good', 'needs_improvement'
  final List<String> mistakes;
  final String? teacherComment;

  const HomeworkHistoryItem({
    required this.id,
    required this.title,
    required this.grade,
    required this.date,
    required this.status,
    required this.mistakes,
    this.teacherComment,
  });

  factory HomeworkHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$HomeworkHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkHistoryItemToJson(this);
}

@JsonSerializable()
class SubjectHistory {
  final String subjectName;
  final List<HomeworkHistoryItem> homeworks;
  final double averageGrade;

  const SubjectHistory({
    required this.subjectName,
    required this.homeworks,
    required this.averageGrade,
  });

  factory SubjectHistory.fromJson(Map<String, dynamic> json) =>
      _$SubjectHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectHistoryToJson(this);
}
