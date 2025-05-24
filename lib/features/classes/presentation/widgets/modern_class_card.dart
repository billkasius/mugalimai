import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../../../core/models/class_model.dart';
import '../../../../../../core/models/subject_model.dart';

class ModernClassCard extends StatelessWidget {
  final ClassModel classModel;
  final SubjectModel subject;
  final VoidCallback onTap;
  final int delay;

  const ModernClassCard({
    super.key,
    required this.classModel,
    required this.subject,
    required this.onTap,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: GestureDetector(
          onTap: onTap,
          child: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
          colors: [
          subject.color.withOpacity(0.8),
      subject.color.withOpacity(0.6),
      ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: subject.color.withOpacity(0.3),
    blurRadius: 15,
    offset: const Offset(0, 8),
    ),
    ],
    ),
    child: Stack(
    children: [
    // Декоративные элементы
    Positioned(
    top: -20,
    right: -20,
    child: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.1),
    ),
    ),
    ),
    Positioned(
    bottom: -10,
    left: -10,
    child: Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.1),
    ),
    ),
    ),

    // Контент
    Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Номер класса
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
    classModel.displayName,
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    ),
    ),
    ),

    const Spacer(),

    // Информация о классе
    Row(
    children: [
    Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(
    Icons.people,
    color: Colors.white,
    size: 20,
    ),
    ),
    const SizedBox(width: 8),
    Expanded(
    child: Text(
    '${classModel.studentCount}',
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),
    ),
    ],
    ),
      const SizedBox(height: 8),

      // Средний балл
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              classModel.averagePerformance >= 4.0
                  ? Icons.trending_up
                  : Icons.trending_flat,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classModel.averagePerformance > 0
                      ? classModel.averagePerformance.toStringAsFixed(1)
                      : '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'средний балл',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      // Кнопка перехода
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Открыть класс',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.9),
              size: 14,
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
}
