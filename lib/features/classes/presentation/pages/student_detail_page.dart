import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';

class StudentDetailPage extends StatelessWidget {
  final StudentModel student;
  final SubjectModel subject;

  const StudentDetailPage({
    super.key,
    required this.student,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: subject.color,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeInUp(
                child: Text(
                  student.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      subject.color,
                      subject.color.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Декоративные элементы
                    Positioned(
                      top: 50,
                      right: -50,
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 600),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),

                    // Аватар ученика
                    Center(
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              student.initials,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildGradeSection(context),
                const SizedBox(height: 24),
                _buildSubjectSection(context),
                const SizedBox(height: 24),
                _buildActionsSection(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSection(BuildContext context) {
    final averageGrade = student.averageGrades[subject.id] ?? 0.0;

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: subject.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.grade,
                      color: subject.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Оценки по предмету',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      subject.color.withOpacity(0.1),
                      subject.color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: subject.color.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: subject.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Средний балл',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      averageGrade > 0 ? averageGrade.toStringAsFixed(1) : '—',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: subject.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectSection(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: subject.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.subject,
                      color: subject.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Информация о предмете',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: subject.color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: subject.color.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: subject.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: subject.color,
                            ),
                          ),
                          Text(
                            'Изучаемый предмет',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return FadeInUp(
        delay: const Duration(milliseconds: 600),
    child: Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: subject.color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
    Icons.settings,
    color: subject.color,
    ),
    ),
    const SizedBox(width: 12),
    Text(
    'Действия',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    const SizedBox(height: 16),
    _buildActionButton(
    context,
    'Проверить ДЗ',
    Icons.assignment,
    subject.color,
    () {
    ScaffoldMessenger.of(context).showSnackBar(                    SnackBar(
      content: Text('Проверка ДЗ для ${student.fullName} по предмету ${subject.name}'),
      backgroundColor: subject.color,
    ),
    );
    },
    ),
      const SizedBox(height: 12),
      _buildActionButton(
        context,
        'Создать задание',
        Icons.add_task,
        Colors.green,
            () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Создание задания для ${student.fullName}'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      _buildActionButton(
        context,
        'Анализ успеваемости',
        Icons.analytics,
        Colors.purple,
            () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Анализ успеваемости ${student.fullName}'),
              backgroundColor: Colors.purple,
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      _buildActionButton(
        context,
        'Связаться с родителями',
        Icons.contact_phone,
        Colors.orange,
            () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Связь с родителями ${student.fullName}'),
              backgroundColor: Colors.orange,
            ),
          );
        },
      ),
    ],
    ),
    ),
    ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}


