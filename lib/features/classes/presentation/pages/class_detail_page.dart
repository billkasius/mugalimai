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
      appBar: AppBar(
        title: Text('Класс ${widget.classModel.displayName}'),
        backgroundColor: widget.subject.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Статистика класса
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Учеников',
                  widget.classModel.studentCount.toString(),
                  Icons.people,
                ),
                _buildStatItem(
                  context,
                  'Предмет',
                  widget.subject.name,
                  Icons.subject,
                ),
                _buildStatItem(
                  context,
                  'Средний балл',
                  widget.classModel.averagePerformance > 0
                      ? widget.classModel.averagePerformance.toStringAsFixed(1)
                      : '—',
                  Icons.grade,
                ),
              ],
            ),
          ),

          // Поиск учеников
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context.read<ClassesBloc>().add(SearchStudents(query));
              },
              decoration: InputDecoration(
                hintText: 'Поиск учеников...',
                prefixIcon: Icon(Icons.search, color: widget.subject.color),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: widget.subject.color),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ClassesBloc>().add(const SearchStudents(''));
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.subject.color.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.subject.color, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.subject.color.withOpacity(0.3)),
                ),
              ),
            ),
          ),

          // Список учеников
          Expanded(
            child: BlocBuilder<ClassesBloc, ClassesState>(
              builder: (context, state) {
                if (state is ClassesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ClassesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ClassesBloc>().add(SelectClass(widget.classModel.id));
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ClassesLoaded) {
                  final students = state.students;

                  if (students.isEmpty && state.searchQuery.isNotEmpty) {
                    return Center(
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
                    );
                  }

                  if (students.isEmpty) {
                    return Center(
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
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return FadeInLeft(
                        delay: Duration(milliseconds: index * 50),
                        child: StudentCard(
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
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('Неизвестное состояние'));
              },
            ),
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
      ) {
    return Column(
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
    );
  }
}
