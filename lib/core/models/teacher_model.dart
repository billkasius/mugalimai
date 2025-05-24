import 'package:json_annotation/json_annotation.dart';

part 'teacher_model.g.dart';

@JsonSerializable()
class TeacherModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String schoolId;
  final List<String> classIds;
  final List<String> subjectIds;
  final bool isAdmin;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  const TeacherModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.schoolId,
    required this.classIds,
    required this.subjectIds,
    this.isAdmin = false,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  // Конвертеры для DateTime
  static DateTime _dateTimeFromJson(String dateString) => DateTime.parse(dateString);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);
}
