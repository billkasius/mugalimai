import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/models/analytics_model.dart';

class ClassPerformanceSection extends StatelessWidget {
  final List<ClassPerformance> classPerformance;

  const ClassPerformanceSection({super.key, required this.classPerformance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 1400),
          child: Text(
            'Производительность классов',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: classPerformance.length,
          itemBuilder: (context, index) {
            final performance = classPerformance[index];
            return FadeInRight(
              delay: Duration(milliseconds: 1500 + (index * 100)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: performance.isImprovement
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: performance.isImprovement
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.class_,
                        color: performance.isImprovement ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Класс ${performance.className}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${performance.totalStudents} учеников',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              performance.isImprovement
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: performance.isImprovement ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${performance.performanceChange.toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: performance.isImprovement ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          performance.isImprovement ? 'улучшение' : 'снижение',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: performance.isImprovement ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
