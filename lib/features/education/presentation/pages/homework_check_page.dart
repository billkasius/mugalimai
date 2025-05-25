// lib/features/homework/presentation/pages/homework_check_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:convert';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/homework_check_model.dart';
import '../../../../core/services/homework_check_service.dart';
import '../../../../core/services/mock_data_service.dart';
import 'homework_result_page.dart';

class HomeworkCheckPage extends StatefulWidget {
  const HomeworkCheckPage({super.key});

  @override
  State<HomeworkCheckPage> createState() => _HomeworkCheckPageState();
}

class _HomeworkCheckPageState extends State<HomeworkCheckPage> {
  final MockDataService _mockDataService = MockDataService();
  final HomeworkCheckService _homeworkCheckService = HomeworkCheckService();
  final PageController _pageController = PageController();

  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  ClassModel? _selectedClass;
  StudentModel? _selectedStudent;
  SubjectModel? _selectedSubject;
  bool _isLoadingClasses = true;
  bool _isLoadingStudents = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _mockDataService.getClasses();
      setState(() {
        _classes = classes;
        _isLoadingClasses = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingClasses = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки классов: $e')),
      );
    }
  }

  Future<void> _loadStudents(String classId) async {
    setState(() {
      _isLoadingStudents = true;
    });

    try {
      final students = await _mockDataService.getStudentsByClass(classId);
      setState(() {
        _students = students;
        _isLoadingStudents = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStudents = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки учеников: $e')),
      );
    }
  }

  void _selectClass(ClassModel classModel) {
    setState(() {
      _selectedClass = classModel;
      _selectedStudent = null;
      _currentStep = 1;
    });
    _loadStudents(classModel.id);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectStudent(StudentModel student) {
    setState(() {
      _selectedStudent = student;
      _currentStep = 2;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        if (_currentStep == 0) {
          _selectedClass = null;
          _selectedStudent = null;
        } else if (_currentStep == 1) {
          _selectedStudent = null;
        }
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Проверка ДЗ'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: _currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        )
            : IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Индикатор прогресса
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Класс', _currentStep >= 0),
                Expanded(child: _buildStepLine(_currentStep >= 1)),
                _buildStepIndicator(1, 'Ученик', _currentStep >= 1),
                Expanded(child: _buildStepLine(_currentStep >= 2)),
                _buildStepIndicator(2, 'Проверка', _currentStep >= 2),
              ],
            ),
          ),

          // Контент
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildClassSelection(),
                _buildStudentSelection(),
                _buildHomeworkCheck(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue : Colors.grey[300],
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
              '${step + 1}',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? Colors.blue : Colors.grey[300],
    );
  }

  Widget _buildClassSelection() {
    if (_isLoadingClasses) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: Text(
              'Выберите класс',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Выберите класс для проверки домашнего задания',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final classModel = _classes[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildClassCard(classModel),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(ClassModel classModel) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange];
    final color = colors[classModel.name.hashCode % colors.length];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _selectClass(classModel),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.6),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.class_,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  classModel.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${classModel.studentCount} учеников',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _selectedClass?.displayName ?? '',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Выберите ученика',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 300),
            child: Text(
              'Выберите ученика для проверки работы',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoadingStudents
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return FadeInLeft(
                  delay: Duration(milliseconds: index * 50),
                  child: _buildStudentCard(student, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentModel student, int index) {
    final avatarColors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.teal,
    ];
    final color = avatarColors[index % avatarColors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectStudent(student),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 24,
                child: Text(
                  student.firstName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Средний балл: ${student.averageGrade.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeworkCheck() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Выбранные данные
          FadeInDown(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выбранные данные',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedClass?.displayName ?? '',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedStudent?.fullName ?? 'Не выбран',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Выбор предмета
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выберите предмет',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: SubjectModel.defaultSubjects.map((subject) {
                        final isSelected = _selectedSubject?.id == subject.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSubject = subject;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? subject.color : subject.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: subject.color,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : subject.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  subject.name,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : subject.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Интеграция PhotoUploadWidget
          if (_selectedStudent != null && _selectedSubject != null)
            PhotoUploadWidget(
              student: _selectedStudent!,
              subject: _selectedSubject!,
              onResult: (HomeworkCheckResponse response, String photoPath) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeworkResultPage(
                      student: _selectedStudent!,
                      subject: _selectedSubject!,
                      response: response,
                      photoPath: photoPath,
                    ),
                  ),
                );
              },
            )
          else
            const Center(
              child: Text('Пожалуйста, выберите ученика и предмет'),
            ),
        ],
      ),
    );
  }
}

class PhotoUploadWidget extends StatefulWidget {
  final StudentModel student;
  final SubjectModel subject;
  final Function(HomeworkCheckResponse, String) onResult;

  const PhotoUploadWidget({
    required this.student,
    required this.subject,
    required this.onResult,
  });

  @override
  _PhotoUploadWidgetState createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  Map<String, dynamic>? _analysisResult;
  String? _errorMessage;

  // URL вашего API
  static const String API_BASE_URL = 'http://localhost:8000';

  static const int STUDENT_ID = 1;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при выборе изображения: $e';
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при съемке фото: $e';
      });
    }
  }

  Future<void> _uploadAndAnalyzeWithBytes() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = 'Пожалуйста, выберите изображение';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      // Читаем файл как bytes
      List<int> imageBytes = await _selectedImage!.readAsBytes();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_BASE_URL/check/ru/'),
      );

      // Добавляем файл из bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: 'image.jpg',
        ),
      );

      // Добавляем student_id
      request.fields['student_id'] = STUDENT_ID.toString();

      print('Отправляем запрос (bytes) на: ${request.url}');
      print('Размер файла: ${imageBytes.length} bytes');
      print('Поля: ${request.fields}');

      // Отправляем запрос
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Статус ответа: ${response.statusCode}');
      print('Тело ответа: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _analysisResult = jsonData;
        });
      } else {
        setState(() {
          _errorMessage = 'Ошибка сервера: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      print('Ошибка при отправке (bytes): $e');
      setState(() {
        _errorMessage = 'Ошибка сети: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadAndAnalyze() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = 'Пожалуйста, выберите изображение';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_BASE_URL/check/ru/'),
      );

      // Добавляем заголовки
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      // Определяем MIME тип на основе расширения файла
      String fileName = path.basename(_selectedImage!.path);
      String mimeType = 'image/jpeg'; // По умолчанию
      String extension = path.extension(fileName).toLowerCase();

      switch (extension) {
        case '.jpg':
        case '.jpeg':
          mimeType = 'image/jpeg';
          break;
        case '.png':
          mimeType = 'image/png';
          break;
        case '.gif':
          mimeType = 'image/gif';
          break;
        case '.webp':
          mimeType = 'image/webp';
          break;
      }

      // Добавляем файл с правильным MIME типом
      var multipartFile = await http.MultipartFile.fromPath(
        'photo',
        _selectedImage!.path,
        filename: fileName,
      );
      request.files.add(multipartFile);

      // Добавляем student_id как строку
      request.fields['student_id'] = STUDENT_ID.toString();

      print('Отправляем запрос на: ${request.url}');
      print('Поля: ${request.fields}');
      print('Файлы: ${request.files.map((f) => '${f.field}: ${f.filename}')}');

      // Отправляем запрос
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Статус ответа: ${response.statusCode}');
      print('Тело ответа: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _analysisResult = jsonData;
        });
      } else {
        // Если первый способ не сработал, пробуем второй
        print('Первый способ не сработал, пробуем отправить через bytes...');
        await _uploadAndAnalyzeWithBytes();
      }
    } catch (e) {
      print('Ошибка при отправке: $e');
      // Пробуем альтернативный способ
      print('Пробуем альтернативный способ отправки...');
      await _uploadAndAnalyzeWithBytes();
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Widget _buildAnalysisResult() {
    if (_analysisResult == null) return const SizedBox.shrink();

    final analysis = _analysisResult!['analysis'] as Map<String, dynamic>;
    final errors = List<String>.from(analysis['errors'] ?? []);
    final aiProbability = analysis['ai_probability'] ?? 0;
    final reason = analysis['reason'] ?? '';
    final originalText = _analysisResult!['original_text'] ?? '';

    return FadeInUp(
      child: Card(
        margin: const EdgeInsets.only(top: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Результат анализа',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Информация о студенте
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Студент: Найден',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('ID: ${_analysisResult!['student_id']}'),
                    Text('Предмет: ${_analysisResult!['subject']}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Распознанный текст
              if (originalText.isNotEmpty) ...[
                Text(
                  'Распознанный текст:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    originalText,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Вероятность ИИ
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: aiProbability < 30
                      ? Colors.green[50]
                      : aiProbability < 70
                      ? Colors.orange[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      aiProbability < 30
                          ? Icons.check_circle
                          : aiProbability < 70
                          ? Icons.warning
                          : Icons.error,
                      color: aiProbability < 30
                          ? Colors.green[700]
                          : aiProbability < 70
                          ? Colors.orange[700]
                          : Colors.red[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Вероятность ИИ: $aiProbability%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: aiProbability < 30
                                  ? Colors.green[700]
                                  : aiProbability < 70
                                  ? Colors.orange[700]
                                  : Colors.red[700],
                            ),
                          ),
                          if (reason.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              reason,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Ошибки
              if (errors.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Найденные ошибки:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...errors.map((error) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Выбор фото
        FadeInDown(
          delay: const Duration(milliseconds: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Добавьте фото работы',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_selectedImage != null) ...[
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                  _analysisResult = null;
                                  _errorMessage = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Фото не выбрано',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isUploading ? null : _pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Галерея'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            foregroundColor: Colors.blue[700],
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.blue[200]!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isUploading ? null : _takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Камера'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[50],
                            foregroundColor: Colors.green[700],
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.green[200]!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Кнопка анализа
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadAndAnalyze,
                        icon: _isUploading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Icon(Icons.analytics),
                        label: Text(_isUploading ? 'Анализ...' : 'Анализировать'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Сообщение об ошибке
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Результат анализа
        _buildAnalysisResult(),
      ],
    );
  }
}