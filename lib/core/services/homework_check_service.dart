// lib/core/services/homework_check_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/homework_check_model.dart';

class HomeworkCheckService {
  final Dio _dio = Dio();
  static const String baseUrl = 'http://localhost:8000'; // Замените на ваш URL

  Future<HomeworkCheckResponse> checkHomework({
    required String studentId,
    required File photo,
    required String subject,
  }) async {
    try {
      String endpoint = '/check/ru/'; // Можно сделать динамическим в зависимости от предмета

      FormData formData = FormData.fromMap({
        'student_id': studentId,
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '$baseUrl$endpoint',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return HomeworkCheckResponse.fromJson(response.data);
      } else {
        throw Exception('Ошибка проверки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  String _getEndpointForSubject(String subject) {
    switch (subject.toLowerCase()) {
      case 'русский язык':
      case 'russian':
        return '/check/ru/';
      case 'кыргыз тили':
      case 'kyrgyz':
        return '/check/ky/';
      case 'математика':
      case 'math':
        return '/check/math/';
      default:
        return '/check/ru/';
    }
  }
}
