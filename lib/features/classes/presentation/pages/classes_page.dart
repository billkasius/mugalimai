// lib/features/classes/presentation/pages/classes_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../shared/widgets/class_card.dart';
import '../../../../shared/widgets/student_card.dart';
import '../../../../core/models/subject_model.dart';
import '../bloc/classes_bloc.dart';
import '../bloc/classes_event.dart';
import '../bloc/classes_state.dart';
import 'student_detail_page.dart'; // Добавить импорт

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassesBloc()..add(LoadClasses()),
      child: const ClassesView(),
    );
  }
}

class ClassesView extends StatefulWidget {
  const ClassesView({super.key});

  @override
  State<ClassesView> createState() => _ClassesViewState();
}

class _ClassesViewState extends State<ClassesView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedClassId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Классы'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<ClassesBloc, ClassesState>(
        builder: (context, state) {
          if (state is ClassesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ClassesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ClassesBloc>().add(LoadClasses());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is ClassesLoaded) {
            return Column(
              children: [
                // Список классов
                if (_selectedClassId == null) ...[
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.classes.length,
                      itemBuilder: (context, index) {
                        final classModel = state.classes[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 100),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClassCard(
                              classModel: classModel,
                              onTap: () {
                                setState(() {
                                  _selectedClassId = classModel.id;
                                });
                                context.read<ClassesBloc>().add(SelectClass(classModel.id));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  // Поиск учеников
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedClassId = null;
                              _searchController.clear();
                            });
                            context.read<ClassesBloc>().add(LoadClasses());
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Поиск учеников...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<ClassesBloc>().add(const SearchStudents(''));
                                },
                              )
                                  : null,
                            ),
                            onChanged: (query) {
                              context.read<ClassesBloc>().add(SearchStudents(query));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Список учеников
                  Expanded(
                    child: state.students.isEmpty
                        ? const Center(
                      child: Text('Ученики не найдены'),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.students.length,
                      itemBuilder: (context, index) {
                        final student = state.students[index];
                        return FadeInLeft(
                          delay: Duration(milliseconds: index * 50),
                          child: StudentCard(
                            student: student,
                            subject: SubjectModel.defaultSubjects.first,
                            onTap: () {
                              // Навигация к деталям ученика
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentDetailPage(
                                    student: student,
                                    subject: SubjectModel.defaultSubjects.first,
                                  ),
                                ),
                              );
                            },
                            delay: index * 50,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          }

          return const Center(child: Text('Неизвестное состояние'));
        },
      ),
    );
  }
}
