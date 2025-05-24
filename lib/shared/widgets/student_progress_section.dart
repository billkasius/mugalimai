import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../shared/widgets/progress_card.dart';
import '../../../../core/models/analytics_model.dart';

class StudentProgressSection extends StatelessWidget {
  final List<StudentProgress> studentProgress;

  const StudentProgressSection({super.key, required this.studentProgress});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    FadeInLeft(
    delay: const Duration(milliseconds: 1000),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    'Прогресс учеников',
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Переход к полному списку')),
        );
      },
      child: const Text('Все'),
    ),
    ],
    ),
    ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: studentProgress.length,
            itemBuilder: (context, index) {
              final progress = studentProgress[index];
              return ProgressCard(
                studentName: progress.studentName,
                percentage: progress.progressPercentage,
                isImprovement: progress.isImprovement,
                subject: progress.subject,
                delay: 1100 + (index * 100),
              );
            },
          ),
        ],
    );
  }
}

