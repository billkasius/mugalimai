import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../shared/widgets/student_card.dart';
import '../bloc/classes_bloc.dart';
import '../bloc/classes_event.dart';
import '../bloc/classes_state.dart';
import 'student_detail_page.dart';

class ClassDetailPage extends StatelessWidget {
  final ClassModel classModel;
  final SubjectModel subject;

  const ClassDetailPage({
    super.key,
    required this.classModel,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassesBloc()..add(SelectClass(classModel.id)),
      child: ClassDetailView(
        classModel: classModel,
        subject: subject,
      ),
    );
  }
}

class ClassDetailView extends StatefulWidget {
  final ClassModel classModel;
  final SubjectModel subject;

  const ClassDetailView({
    super.key,
    required this.classModel,
    required this.subject,
  });

  @override
  State<ClassDetailView> createState() => _ClassDetailViewState();
}

class _ClassDetailViewState extends State<ClassDetailView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Красивый AppBar с градиентом предмета
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: widget.subject.color,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeInUp(
                child: Text(
                  'Класс ${widget.classModel.displayName}',
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
                      widget.subject.color,
                      widget.subject.color.withOpacity(0.8),
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
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: FadeInLeft(
                        delay: const Duration(milliseconds: 800),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),

                    // Статистика класса
                    Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            'Учеников',
                            widget.classModel.studentCount.toString(),
                            Icons.people,
                            400,
                          ),
                          _buildStatItem(
                            context,
                            'Предмет',
                            widget.subject.name,
                            Icons.subject,
                            600,
                          ),
                          _buildStatItem(
                            context,
                            'Средний балл',
                            widget.classModel.averagePerformance > 0
                                ? widget.classModel.averagePerformance.toStringAsFixed(1)
                                : '—',
                            Icons.grade,
                            800,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Поиск учеников
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchHeaderDelegate(
              searchController: _searchController,
              subject: widget.subject,
              onSearchChanged: (query) {
                context.read<ClassesBloc>().add(SearchStudents(query));
              },
            ),
          ),

          // Список учеников
          BlocBuilder<ClassesBloc, ClassesState>(
            builder: (context, state) {
              if (state is ClassesLoaded) {
                final students = state.filteredStudents;

                if (students.isEmpty && state.searchQuery.isNotEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInDown(
                            child: Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              'Ученики не найдены',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeInUp(
                            delay: const Duration(milliseconds: 400),
                            child: Text(
                              'Попробуйте изменить запрос',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (students.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInDown(
                            child: Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              'В классе пока нет учеников',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final student = students[index];
                        return StudentCard(
                          student: student,
                          subject: widget.subject,
                          delay: index * 50,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentDetailPage(
                                  student: student,
                                  subject: widget.subject,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: students.length,
                    ),
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      int delay,
      ) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final SubjectModel subject;
  final Function(String) onSearchChanged;

  _SearchHeaderDelegate({
    required this.searchController,
    required this.subject,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Поиск учеников...',
          prefixIcon: Icon(Icons.search, color: subject.color),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: subject.color),
            onPressed: () {
              searchController.clear();
              onSearchChanged('');
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: subject.color.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: subject.color, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: subject.color.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
