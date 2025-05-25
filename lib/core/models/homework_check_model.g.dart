// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeworkCheckRequest _$HomeworkCheckRequestFromJson(
        Map<String, dynamic> json) =>
    HomeworkCheckRequest(
      studentId: json['studentId'] as String,
      photoPath: json['photoPath'] as String,
      subject: json['subject'] as String,
    );

Map<String, dynamic> _$HomeworkCheckRequestToJson(
        HomeworkCheckRequest instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'photoPath': instance.photoPath,
      'subject': instance.subject,
    };

HomeworkCheckResponse _$HomeworkCheckResponseFromJson(
        Map<String, dynamic> json) =>
    HomeworkCheckResponse(
      status: json['status'] as String,
      studentId: (json['student_id'] as num).toInt(),
      studentName: json['student_name'] as String,
      subject: json['subject'] as String,
      originalText: json['original_text'] as String,
      analysis:
          HomeworkAnalysis.fromJson(json['analysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeworkCheckResponseToJson(
        HomeworkCheckResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'subject': instance.subject,
      'original_text': instance.originalText,
      'analysis': instance.analysis,
    };

HomeworkAnalysis _$HomeworkAnalysisFromJson(Map<String, dynamic> json) =>
    HomeworkAnalysis(
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
      aiProbability: (json['ai_probability'] as num).toInt(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$HomeworkAnalysisToJson(HomeworkAnalysis instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'ai_probability': instance.aiProbability,
      'reason': instance.reason,
    };

HomeworkSubmission _$HomeworkSubmissionFromJson(Map<String, dynamic> json) =>
    HomeworkSubmission(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      originalText: json['originalText'] as String,
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
      aiProbability: (json['aiProbability'] as num).toInt(),
      aiReason: json['aiReason'] as String,
      grade: (json['grade'] as num).toDouble(),
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      photoPath: json['photoPath'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$HomeworkSubmissionToJson(HomeworkSubmission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'subject': instance.subject,
      'topic': instance.topic,
      'originalText': instance.originalText,
      'errors': instance.errors,
      'aiProbability': instance.aiProbability,
      'aiReason': instance.aiReason,
      'grade': instance.grade,
      'submissionDate': instance.submissionDate.toIso8601String(),
      'photoPath': instance.photoPath,
      'status': instance.status,
    };
