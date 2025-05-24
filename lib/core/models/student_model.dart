import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String classId;
  final List<String> subjects;
  final Map<String, double> averageGrades;
  final String? photoUrl;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? birthDate;

  const StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.classId,
    required this.subjects,
    required this.averageGrades,
    this.photoUrl,
    this.birthDate,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';

  // Конвертеры для DateTime
  static DateTime? _dateTimeFromJson(String? dateString) =>
      dateString != null ? DateTime.parse(dateString) : null;
  static String? _dateTimeToJson(DateTime? dateTime) => dateTime?.toIso8601String();

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}
