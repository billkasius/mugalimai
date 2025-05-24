import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../core/models/analytics_model.dart';

class StatsSection extends StatelessWidget {
  final DashboardStats stats;

  const StatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 200),
          child: Text(
            'Статистика',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            StatsCard(
              title: 'Всего учеников',
              value: stats.totalStudents.toString(),
              icon: Icons.people,
              color: Colors.blue,
              delay: 300,
            ),
            StatsCard(
              title: 'Классов',
              value: stats.totalClasses.toString(),
              icon: Icons.class_,
              color: Colors.green,
              delay: 400,
            ),
            StatsCard(
              title: 'ДЗ проверено',
              value: stats.homeworksChecked.toString(),
              icon: Icons.assignment_turned_in,
              color: Colors.orange,
              delay: 500,
            ),
            StatsCard(
              title: 'Тестов создано',
              value: stats.testsGenerated.toString(),
              icon: Icons.quiz,
              color: Colors.purple,
              delay: 600,
            ),
          ],
        ),
      ],
    );
  }
}
