import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../shared/localization/generated/l10n.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/models/analytics_model.dart';
import '../../../../shared/widgets/class_perfomance_section.dart';
import '../../../../shared/widgets/quick_actions_section.dart';
import '../../../../shared/widgets/stats_section.dart';
import '../../../../shared/widgets/student_progress_section.dart';
import '../../../../shared/widgets/tips_section.dart';
import '../../../../shared/widgets/welcome_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Моковые данные
  final DashboardStats _stats = const DashboardStats(
    totalStudents: 152,
    totalClasses: 6,
    homeworksChecked: 89,
    testsGenerated: 23,
  );

  final List<StudentProgress> _studentProgress = [
    const StudentProgress(
      studentId: '1',
      studentName: 'Айдар Сабырбеков',
      progressPercentage: 26,
      isImprovement: true,
      subject: 'Математика',
    ),
    const StudentProgress(
      studentId: '2',
      studentName: 'Гульмира Токтогулова',
      progressPercentage: 18,
      isImprovement: true,
      subject: 'Русский язык',
    ),
    const StudentProgress(
      studentId: '3',
      studentName: 'Эрлан Мамытов',
      progressPercentage: 3,
      isImprovement: false,
      subject: 'Кыргызский язык',
    ),
  ];

  final List<ClassPerformance> _classPerformance = [
    const ClassPerformance(
      classId: '1',
      className: '4 Б',
      performanceChange: -8,
      isImprovement: false,
      totalStudents: 19,
    ),
    const ClassPerformance(
      classId: '2',
      className: '4 А',
      performanceChange: 15,
      isImprovement: true,
      totalStudents: 21,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WelcomeSection(),
                const SizedBox(height: 24),
                StatsSection(stats: _stats),
                const SizedBox(height: 24),
                const QuickActionsSection(),
                const SizedBox(height: 24),
                StudentProgressSection(studentProgress: _studentProgress),
                const SizedBox(height: 24),
                ClassPerformanceSection(classPerformance: _classPerformance),
                const SizedBox(height: 24),
                const TipsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Обновление данных...'),
        duration: Duration(seconds: 1),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    _animationController.reset();
    _animationController.forward();

    setState(() {});
  }
}
