// lib/shared/widgets/student_card.dart
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
    return FadeInLeft(
      delay: Duration(milliseconds: delay),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Аватар ученика
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subject.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      student.initials,
                      style: TextStyle(
                        color: subject.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Информация об ученике
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
                      const SizedBox(height: 8),

                      // 3 предмета с оценками
                      Row(
                        children: [
                          _buildSubjectGrade(context, 'Кыргыз тили', '4.5', Colors.green),
                          const SizedBox(width: 12),
                          _buildSubjectGrade(context, 'Математика', '4.2', Colors.blue),
                          const SizedBox(width: 12),
                          _buildSubjectGrade(context, 'Русский язык', '4.8', Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),

                // Стрелка
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectGrade(BuildContext context, String subject, String grade, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            grade,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subject,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
