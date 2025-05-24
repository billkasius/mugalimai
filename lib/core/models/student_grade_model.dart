import 'package:json_annotation/json_annotation.dart';

part 'student_grade_model.g.dart';

@JsonSerializable()
class StudentGradeModel {
  final String id;
  final String studentId;
  final String subjectId;
  final double grade;
  final String? comment;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  final String teacherId;

  const StudentGradeModel({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.grade,
    this.comment,
    required this.createdAt,
    required this.teacherId,
  });

  // Конвертеры для DateTime
  static DateTime _dateTimeFromJson(String dateString) => DateTime.parse(dateString);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) =>
      _$StudentGradeModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentGradeModelToJson(this);
}
