// lib/features/education/presentation/pages/education_page.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'homework_check_page.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Красивый AppBar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.indigo,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Учебный процесс',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo,
                      Colors.blue,
                      Colors.lightBlue,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Декоративные элементы
                    Positioned(
                      top: 50,
                      right: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // Иконка образования
                    const Positioned(
                      bottom: 60,
                      left: 20,
                      child: Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Контент
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),

                // Заголовок секции
                FadeInDown(
                  child: Text(
                    'Основные функции',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Карточка проверки ДЗ
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: _buildFeatureCard(
                    context,
                    title: 'Проверка домашних заданий',
                    subtitle: 'ИИ-анализ работ учеников с распознаванием текста',
                    icon: Icons.assignment_turned_in,
                    color: Colors.blue,
                    features: [
                      'Распознавание текста с фото',
                      'Поиск ошибок и опечаток',
                      'Определение ИИ-генерации',
                      'Автоматическая оценка',
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeworkCheckPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Карточка генерации заданий (будущая функция)
                FadeInRight(
                  delay: const Duration(milliseconds: 400),
                  child: _buildFeatureCard(
                    context,
                    title: 'Генерация заданий',
                    subtitle: 'Создание персонализированных заданий для учеников',
                    icon: Icons.auto_awesome,
                    color: Colors.purple,
                    features: [
                      'ИИ-генерация заданий',
                      'Адаптация под уровень ученика',
                      'Различные типы заданий',
                      'Автоматическая проверка',
                    ],
                    isComingSoon: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Функция будет доступна в следующем обновлении'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Карточка аналитики (будущая функция)
                FadeInLeft(
                  delay: const Duration(milliseconds: 600),
                  child: _buildFeatureCard(
                    context,
                    title: 'Аналитика успеваемости',
                    subtitle: 'Детальная статистика и рекомендации по обучению',
                    icon: Icons.analytics,
                    color: Colors.green,
                    features: [
                      'Графики успеваемости',
                      'Анализ слабых мест',
                      'Рекомендации по улучшению',
                      'Сравнение с классом',
                    ],
                    isComingSoon: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Функция будет доступна в следующем обновлении'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Статистика
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.indigo[600],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Статистика использования',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                '127',
                                'Проверено работ',
                                Icons.assignment_turned_in,
                                Colors.blue,
                              ),
                              _buildStatItem(
                                context,
                                '89%',
                                'Точность ИИ',
                                Icons.psychology,
                                Colors.purple,
                              ),
                              _buildStatItem(
                                context,
                                '4.2',
                                'Средний балл',
                                Icons.grade,
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required List<String> features,
        required VoidCallback onTap,
        bool isComingSoon = false,
      }) {
    return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
    ),
    child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
    color.withOpacity(0.1),
    color.withOpacity(0.05),
    ],
    ),
    ),
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: color.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(
    icon,
    color: color,
    size: 28,
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Expanded(
    child: Text(
    title,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    color: color,
    ),
    ),
    ),
    if (isComingSoon)
    Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
    ),
    decoration: BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(8),
    ),
    child: const Text(
    'Скоро',
    style: TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 4),
    Text(
    subtitle,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Colors.grey[600],
    ),
    ),
    ],
    ),
    ),
    ],
    ),

    const SizedBox(height: 16),

    // Список возможностей
    ...features.map(
    (feature) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    ),
    ),

      const SizedBox(height: 12),

      // Кнопка действия
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isComingSoon ? Icons.schedule : Icons.arrow_forward,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isComingSoon ? 'Скоро доступно' : 'Открыть',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      Color color,
      ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

