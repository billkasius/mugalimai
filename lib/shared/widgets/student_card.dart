import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/models/student_model.dart';
import '../../core/models/subject_model.dart';

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final SubjectModel subject;
  final VoidCallback onTap;
  final int delay;

  const StudentCard({
    super.key,
    required this.student,
    required this.subject,
    required this.onTap,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final averageGrade = student.averageGrades.values.isNotEmpty
        ? student.averageGrades.values.reduce((a, b) => a + b) / student.averageGrades.length
        : 0.0;

    return FadeInLeft(
      delay: Duration(milliseconds: delay),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: subject.color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Аватар с цветом предмета
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          subject.color.withOpacity(0.8),
                          subject.color.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        student.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Информация о студенте
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subject.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Средний балл
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: averageGrade >= 4.0
                              ? Colors.green.withOpacity(0.1)
                              : averageGrade >= 3.0
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: averageGrade >= 4.0
                                ? Colors.green.withOpacity(0.3)
                                : averageGrade >= 3.0
                                ? Colors.orange.withOpacity(0.3)
                                : Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          averageGrade > 0 ? averageGrade.toStringAsFixed(1) : '—',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: averageGrade >= 4.0
                                ? Colors.green
                                : averageGrade >= 3.0
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: subject.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
