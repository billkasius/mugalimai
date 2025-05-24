// lib/features/classes/presentation/pages/student_detail_page.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/services/mock_data_service.dart';
import '../../../../core/models/student_history_model.dart';

class StudentDetailPage extends StatefulWidget {
  final StudentModel student;
  final SubjectModel subject;

  const StudentDetailPage({
    super.key,
    required this.student,
    required this.subject,
  });

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MockDataService _mockDataService = MockDataService();

  List<StudentHistoryModel> _history = [];
  List<WeeklyPerformance> _weeklyPerformance = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final history = await _mockDataService.getStudentHistory(widget.student.id);
      final performance = await _mockDataService.getWeeklyPerformance(widget.student.id);

      setState(() {
        _history = history;
        _weeklyPerformance = performance;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.fullName),
        backgroundColor: widget.subject.color,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'История ДЗ'),
            Tab(text: 'Успеваемость'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(),
          _buildPerformanceTab(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getSubjectColor(item.subject).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getSubjectIcon(item.subject),
                  color: _getSubjectColor(item.subject),
                ),
              ),
              title: Text(item.homeworkTitle),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.subject),
                  Text(
                    _formatDate(item.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (item.comment != null)
                    Text(
                      item.comment!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getGradeColor(item.grade).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.grade.toString(),
                  style: TextStyle(
                    color: _getGradeColor(item.grade),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          children: [
      // Общая статистика
      FadeInDown(
      child: Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Средний балл', '4.3', Icons.grade),
          _buildStatItem('Выполнено ДЗ', '34/40', Icons.assignment_turned_in),
          _buildStatItem('Процент', '85%', Icons.trending_up),
        ],
      ),
    ),
    ),
    ),
    const SizedBox(height: 16),

    // График по неделям
    Expanded(
    child: ListView.builder(
    itemCount: _weeklyPerformance.length,
    itemBuilder: (context, index) {
    final week = _weeklyPerformance[index];
    return FadeInLeft(
    delay: Duration(milliseconds: index * 100),
    child: Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
    padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                week.week,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getGradeColor(week.averageGrade).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  week.averageGrade.toStringAsFixed(1),
                  style: TextStyle(
                    color: _getGradeColor(week.averageGrade),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Прогресс бар выполнения ДЗ
          Row(
            children: [
              Text(
                'Выполнено: ${week.homeworksCompleted}/${week.totalHomeworks}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Text(
                '${(week.completionRate * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: week.completionRate,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getGradeColor(week.averageGrade),
            ),
          ),
        ],
      ),
    ),
    ),
    );
    },
    ),
    ),
          ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: widget.subject.color),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.subject.color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Кыргыз тили':
        return Colors.green;
      case 'Математика':
        return Colors.blue;
      case 'Русский язык':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Кыргыз тили':
        return Icons.language;
      case 'Математика':
        return Icons.calculate;
      case 'Русский язык':
        return Icons.text_fields;
      default:
        return Icons.book;
    }
  }

  Color _getGradeColor(double grade) {
    if (grade >= 4.5) return Colors.green;
    if (grade >= 4.0) return Colors.blue;
    if (grade >= 3.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Сегодня';
    if (difference == 1) return 'Вчера';
    if (difference < 7) return '$difference дн. назад';

    return '${date.day}.${date.month}.${date.year}';
  }
}

