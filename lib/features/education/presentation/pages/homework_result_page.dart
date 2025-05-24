// lib/features/homework/presentation/pages/homework_result_page.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:io';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/homework_check_model.dart';
import '../../../../core/models/student_history_model.dart';
import '../../../../core/services/mock_data_service.dart';

class HomeworkResultPage extends StatefulWidget {
  final StudentModel student;
  final SubjectModel subject;
  final HomeworkCheckResponse response;
  final String photoPath;

  const HomeworkResultPage({
    super.key,
    required this.student,
    required this.subject,
    required this.response,
    required this.photoPath,
  });

  @override
  State<HomeworkResultPage> createState() => _HomeworkResultPageState();
}

class _HomeworkResultPageState extends State<HomeworkResultPage> {
  final TextEditingController _topicController = TextEditingController();
  final MockDataService _mockDataService = MockDataService();
  double _grade = 4.0;
  bool _isSaving = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _saveHomework() async {
    if (_topicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите тему работы')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Создаем запись в истории
      final historyItem = StudentHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: widget.student.id,
        subject: widget.subject.name,
        homeworkTitle: _topicController.text.trim(),
        grade: _grade,
        status: 'checked',
        date: DateTime.now(),
        comment: widget.response.analysis.errors.isNotEmpty
            ? 'Найдены ошибки: ${widget.response.analysis.errors.length}'
            : 'Отличная работа!',
      );

      // Здесь можно добавить сохранение в локальную БД или отправку на сервер

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Работа сохранена!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Color _getAiProbabilityColor(int probability) {
    if (probability <= 30) return Colors.green;
    if (probability <= 60) return Colors.orange;
    return Colors.red;
  }

  String _getAiProbabilityText(int probability) {
    if (probability <= 30) return 'Низкая вероятность ИИ';
    if (probability <= 60) return 'Средняя вероятность ИИ';
    return 'Высокая вероятность ИИ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результат проверки'),
        backgroundColor: widget.subject.color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        // Информация об ученике
        FadeInDown(
        child: Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.subject.color,
              child: Text(
                widget.student.firstName[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.subject.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.subject.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    ),

    const SizedBox(height: 16),

    // Фото работы
    FadeInLeft(
    delay: const Duration(milliseconds: 200),
    child: Card(
    child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Фото работы',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 12),
    Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    image: DecorationImage(
    image: FileImage(File(widget.photoPath)),
    fit: BoxFit.cover,
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),

    const SizedBox(height: 16),

    // Распознанный текст
    FadeInRight(
    delay: const Duration(milliseconds: 400),
    child: Card(
    child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Распознанный текст',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 12),
    Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
    widget.response.originalText,
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    ),
    ],
    ),
    ),
    ),
    ),

    const SizedBox(height: 16),

    // Анализ ИИ
    FadeInUp(
    delay: const Duration(milliseconds: 600),
    child: Card(
    child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Icon(
    Icons.psychology,
    color: _getAiProbabilityColor(widget.response.analysis.aiProbability),
    ),
    const SizedBox(width: 8),
    Text(
    'Анализ ИИ',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    const SizedBox(height: 12),

    // Вероятность ИИ
    Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: _getAiProbabilityColor(widget.response.analysis.aiProbability).withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
    color: _getAiProbabilityColor(widget.response.analysis.aiProbability).withOpacity(0.3),
    ),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    _getAiProbabilityText(widget.response.analysis.aiProbability),
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: _getAiProbabilityColor(widget.response.analysis.aiProbability),
    ),
    ),
    Text(
    '${widget.response.analysis.aiProbability}%',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: _getAiProbabilityColor(widget.response.analysis.aiProbability),
    ),
    ),
    ],
    ),
    const SizedBox(height: 8),
    LinearProgressIndicator(
    value: widget.response.analysis.aiProbability / 100,
    backgroundColor: Colors.grey[300],
    valueColor: AlwaysStoppedAnimation<Color>(
    _getAiProbabilityColor(widget.response.analysis.aiProbability),
    ),
    ),
    ],
    ),
    ),

    const SizedBox(height: 12),

    // Объяснение
    Text(
    'Объяснение:',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 4),
    Text(
    widget.response.analysis.reason,
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    ],
    ),
    ),
    ),
    ),

    const SizedBox(height: 16),

    // Ошибки
    if (widget.response.analysis.errors.isNotEmpty)
    FadeInLeft(
    delay: const Duration(milliseconds: 800),
    child: Card(
    child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Icon(Icons.error_outline, color: Colors.red[600]),
    const SizedBox(width: 8),
    Text(
    'Найденные ошибки (${widget.response.analysis.errors.length})',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    const SizedBox(height: 12),
    ...widget.response.analysis.errors.asMap().entries.map(
    (entry) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
    color: Colors.red[100],
    shape: BoxShape.circle,
    ),
    child: Center(
    child: Text(
    '${entry.key + 1}',
    style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.red[600],
    ),
    ),
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Text(
    entry.value,
    style: Theme.of(context).textTheme.bodyMedium,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),

    const SizedBox(height: 16),

    // Тема и оценка
    FadeInRight(
    delay: const Duration(milliseconds: 1000),
    child: Card(
    child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Оценка работы',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 16),
      // Поле для темы
      TextField(
        controller: _topicController,
        decoration: InputDecoration(
          labelText: 'Тема работы',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: const Icon(Icons.topic),
        ),
      ),

      const SizedBox(height: 16),

      // Выбор оценки
      Text(
        'Оценка: ${_grade.toStringAsFixed(1)}',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Slider(
        value: _grade,
        min: 2.0,
        max: 5.0,
        divisions: 6,
        activeColor: widget.subject.color,
        label: _grade.toStringAsFixed(1),
        onChanged: (value) {
          setState(() {
            _grade = value;
          });
        },
      ),

      // Индикаторы оценок
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGradeIndicator('2.0', Colors.red),
          _buildGradeIndicator('3.0', Colors.orange),
          _buildGradeIndicator('4.0', Colors.blue),
          _buildGradeIndicator('5.0', Colors.green),
        ],
      ),
    ],
    ),
    ),
    ),
    ),

              const SizedBox(height: 24),

              // Кнопка сохранения
              FadeInUp(
                delay: const Duration(milliseconds: 1200),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveHomework,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.subject.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Сохраняем...'),
                      ],
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 8),
                        Text(
                          'Сохранить работу',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildGradeIndicator(String grade, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          grade,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

