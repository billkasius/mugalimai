// lib/core/models/homework_check_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'homework_check_model.g.dart';

@JsonSerializable()
class HomeworkCheckRequest {
  final String studentId;
  final String photoPath;
  final String subject;

  const HomeworkCheckRequest({
    required this.studentId,
    required this.photoPath,
    required this.subject,
  });

  factory HomeworkCheckRequest.fromJson(Map<String, dynamic> json) =>
      _$HomeworkCheckRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkCheckRequestToJson(this);
}

@JsonSerializable()
class HomeworkCheckResponse {
  final String status;
  @JsonKey(name: 'student_id')
  final int studentId;
  @JsonKey(name: 'student_name')
  final String studentName;
  final String subject;
  @JsonKey(name: 'original_text')
  final String originalText;
  final HomeworkAnalysis analysis;

  const HomeworkCheckResponse({
    required this.status,
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.originalText,
    required this.analysis,
  });

  factory HomeworkCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeworkCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkCheckResponseToJson(this);
}

@JsonSerializable()
class HomeworkAnalysis {
  final List<String> errors;
  @JsonKey(name: 'ai_probability')
  final int aiProbability;
  final String reason;

  const HomeworkAnalysis({
    required this.errors,
    required this.aiProbability,
    required this.reason,
  });

  factory HomeworkAnalysis.fromJson(Map<String, dynamic> json) =>
      _$HomeworkAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkAnalysisToJson(this);
}

@JsonSerializable()
class HomeworkSubmission {
  final String id;
  final String studentId;
  final String studentName;
  final String subject;
  final String topic;
  final String originalText;
  final List<String> errors;
  final int aiProbability;
  final String aiReason;
  final double grade;
  final DateTime submissionDate;
  final String photoPath;
  final String status; // 'pending', 'checked', 'needs_review'

  const HomeworkSubmission({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.topic,
    required this.originalText,
    required this.errors,
    required this.aiProbability,
    required this.aiReason,
    required this.grade,
    required this.submissionDate,
    required this.photoPath,
    required this.status,
  });

  factory HomeworkSubmission.fromJson(Map<String, dynamic> json) =>
      _$HomeworkSubmissionFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkSubmissionToJson(this);
}
