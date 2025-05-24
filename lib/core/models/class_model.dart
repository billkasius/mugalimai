import 'package:json_annotation/json_annotation.dart';
import 'student_model.dart';

part 'class_model.g.dart';

@JsonSerializable()
class ClassModel {
  final String id;
  final String name;
  final int grade;
  final String letter;
  final int studentCount;
  final double averagePerformance;
  final List<StudentModel> students;
  final String teacherId;

  const ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.letter,
    required this.studentCount,
    required this.averagePerformance,
    required this.students,
    required this.teacherId,
  });

  String get displayName => '$grade$letter класс';


  ClassModel copyWith({
    String? id,
    String? name,
    int? grade,
    String? letter,
    int? studentCount,
    double? averagePerformance,
    List<StudentModel>? students,
    String? teacherId,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      letter: letter ?? this.letter,
      studentCount: studentCount ?? this.studentCount,
      averagePerformance: averagePerformance ?? this.averagePerformance,
      students: students ?? this.students,
      teacherId: teacherId ?? this.teacherId,
    );
  }

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
