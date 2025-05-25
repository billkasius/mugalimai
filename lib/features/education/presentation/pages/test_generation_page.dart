import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/services/mock_data_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TestGenerationPage extends StatefulWidget {
  const TestGenerationPage({super.key});

  @override
  State<TestGenerationPage> createState() => _TestGenerationPageState();
}

class _TestGenerationPageState extends State<TestGenerationPage> {
  final MockDataService _mockDataService = MockDataService();
  final PageController _pageController = PageController();

  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  List<HomeworkModel> _homeworks = [];
  ClassModel? _selectedClass;
  StudentModel? _selectedStudent;
  SubjectModel? _selectedSubject;
  HomeworkModel? _selectedHomework;
  bool _isLoadingClasses = true;
  bool _isLoadingStudents = false;
  bool _isGeneratingTest = false;
  int _currentStep = 0;
  Map<String, dynamic>? _testResult;
  String? _errorMessage;

  static const String API_BASE_URL = 'http://localhost:8000';

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _initializeHomeworks();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializeHomeworks() {
    final random = Random();
    _homeworks = List.generate(5, (index) {
      final id = (index + 1).toString();
      final date = DateTime.now().subtract(Duration(days: random.nextInt(30)));
      return HomeworkModel(
        id: id,
        description: 'Домашнее задание #$id',
        date: '${date.day}.${date.month}.${date.year}',
      );
    });
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
      _selectedSubject = null;
      _selectedHomework = null;
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
      _selectedSubject = null;
      _selectedHomework = null;
      _currentStep = 2;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectSubject(SubjectModel subject) {
    setState(() {
      _selectedSubject = subject;
      _selectedHomework = null;
      _currentStep = 3;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectHomework(HomeworkModel homework) {
    setState(() {
      _selectedHomework = homework;
      _currentStep = 4;
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
          _selectedSubject = null;
          _selectedHomework = null;
          _testResult = null;
        } else if (_currentStep == 1) {
          _selectedStudent = null;
          _selectedSubject = null;
          _selectedHomework = null;
          _testResult = null;
        } else if (_currentStep == 2) {
          _selectedSubject = null;
          _selectedHomework = null;
          _testResult = null;
        } else if (_currentStep == 3) {
          _selectedHomework = null;
          _testResult = null;
        }
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _generateTest() async {
    if (_selectedStudent == null || _selectedSubject == null || _selectedHomework == null) {
      setState(() {
        _errorMessage = 'Пожалуйста, выберите ученика, предмет и задание';
      });
      return;
    }

    setState(() {
      _isGeneratingTest = true;
      _errorMessage = null;
      _testResult = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/analysis/create_test/${_selectedHomework!.id}/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _testResult = jsonData;
        });
      } else {
        setState(() {
          _errorMessage = 'Ошибка сервера: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка сети: $e';
      });
    } finally {
      setState(() {
        _isGeneratingTest = false;
      });
    }
  }

  Future<void> _downloadAsPdf() async {
    if (_testResult == null) return;

    final pdf = pw.Document();
    final questions = _testResult!['questions'] as List<dynamic>;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Тест по предмету: ${_selectedSubject!.name}',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Класс: ${_selectedClass!.displayName}',
              style: const pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Ученик: ${_selectedStudent!.fullName}',
              style: const pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Задание ID: ${_selectedHomework!.id}',
              style: const pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 20),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final question = entry.value as Map<String, dynamic>;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '$index. ${question['question']}',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 8),
                  ...List<String>.from(question['choices']).asMap().entries.map((choice) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
                      child: pw.Text(
                        '${String.fromCharCode(97 + choice.key)}. ${choice.value}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    );
                  }),
                  pw.SizedBox(height: 16),
                ],
              );
            }),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'test_${_selectedHomework!.id}_${_selectedSubject!.id}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Генерация тестов'),
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
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Класс', _currentStep >= 0),
                Expanded(child: _buildStepLine(_currentStep >= 1)),
                _buildStepIndicator(1, 'Ученик', _currentStep >= 1),
                Expanded(child: _buildStepLine(_currentStep >= 2)),
                _buildStepIndicator(2, 'Предмет', _currentStep >= 2),
                Expanded(child: _buildStepLine(_currentStep >= 3)),
                _buildStepIndicator(3, 'Задание', _currentStep >= 3),
                Expanded(child: _buildStepLine(_currentStep >= 4)),
                _buildStepIndicator(4, 'Генерация', _currentStep >= 4),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildClassSelection(),
                _buildStudentSelection(),
                _buildSubjectSelection(),
                _buildHomeworkSelection(),
                _buildTestGeneration(),
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
              'Выберите класс для генерации теста',
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
                const Icon(
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
              'Выберите ученика для генерации теста',
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

  Widget _buildSubjectSelection() {
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
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedStudent?.fullName ?? '',
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
              'Выберите предмет',
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
              'Выберите предмет для генерации теста',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SubjectModel.defaultSubjects.map((subject) {
                final isSelected = _selectedSubject?.id == subject.id;
                return FadeInUp(
                  delay: Duration(milliseconds: SubjectModel.defaultSubjects.indexOf(subject) * 100),
                  child: GestureDetector(
                    onTap: () => _selectSubject(subject),
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
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkSelection() {
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
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedStudent?.fullName ?? '',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Text(
                  _selectedSubject?.name ?? '',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Выберите задание',
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
              'Выберите домашнее задание для генерации теста',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _homeworks.length,
              itemBuilder: (context, index) {
                final homework = _homeworks[index];
                return FadeInLeft(
                  delay: Duration(milliseconds: index * 50),
                  child: _buildHomeworkCard(homework, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard(HomeworkModel homework, int index) {
    final avatarColors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
    ];
    final color = avatarColors[index % avatarColors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectHomework(homework),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 24,
                child: Text(
                  homework.id,
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
                      homework.description,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Дата: ${homework.date}',
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

  Widget _buildTestGeneration() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected data
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedSubject?.name ?? '',
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
                        Text(
                          'Задание: ${'Выбрано' ?? 'Не выбрано'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
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

          // Generate test button
          FadeInDown(
            delay: const Duration(milliseconds: 400),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGeneratingTest ? null : _generateTest,
                icon: _isGeneratingTest
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Icon(Icons.create),
                label: Text(_isGeneratingTest ? 'Генерация...' : 'Сгенерировать тест'),
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
          ),

          // Error message
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            FadeInDown(
              delay: const Duration(milliseconds: 500),
              child: Container(
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
            ),
          ],

          // Test result
          if (_testResult != null) ...[
            const SizedBox(height: 16),
            FadeInUp(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Сгенерированный тест',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: _downloadAsPdf,
                            icon: const Icon(Icons.download),
                            color: Colors.blue[700],
                            tooltip: 'Скачать как PDF',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...(_testResult!['questions'] as List<dynamic>).asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final question = entry.value as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$index. ${question['question']}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...List<String>.from(question['choices']).asMap().entries.map((choice) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 4),
                                child: Text(
                                  '${String.fromCharCode(97 + choice.key)}. ${choice.value}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HomeworkModel {
  final String id;
  final String description;
  final String date;

  HomeworkModel({
    required this.id,
    required this.description,
    required this.date,
  });
}