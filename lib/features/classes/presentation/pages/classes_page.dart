import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../shared/localization/generated/l10n.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/classes_bloc.dart';
import '../bloc/classes_event.dart';
import '../bloc/classes_state.dart';
import '../widgets/subject_selector.dart';
import '../widgets/modern_class_card.dart';
import 'class_detail_page.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return BlocProvider(
            create: (context) => ClassesBloc()..add(LoadClasses(authState.user.id)),
            child: const ClassesView(),
          );
        }
        return const Center(child: Text('Не авторизован'));
      },
    );
  }
}

class ClassesView extends StatelessWidget {
  const ClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      body: BlocBuilder<ClassesBloc, ClassesState>(
        builder: (context, state) {
          if (state is ClassesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ClassesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    child: Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.read<ClassesBloc>().add(LoadClasses(authState.user.id));
                        }
                      },
                      child: const Text('Повторить'),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ClassesLoaded) {
            return CustomScrollView(
              slivers: [
                // Красивый AppBar с градиентом
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: FadeInUp(
                      child: Text(
                        l10n.classes,
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
                          colors: state.selectedSubject != null
                              ? [
                            state.selectedSubject!.color,
                            state.selectedSubject!.color.withOpacity(0.7),
                          ]
                              : [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withOpacity(0.7),
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
                        ],
                      ),
                    ),
                  ),
                ),

                // Селектор предметов
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SubjectSelectorDelegate(
                    subjects: state.subjects,
                    selectedSubject: state.selectedSubject,
                    onSubjectChanged: (subjectId) {
                      context.read<ClassesBloc>().add(SelectSubject(subjectId));
                    },
                  ),
                ),

                // Список классов
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: state.classes.isEmpty
                      ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInDown(
                            child: Icon(
                              Icons.class_,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              'У вас нет доступных классов',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final classModel = state.classes[index];
                        return ModernClassCard(
                          classModel: classModel,
                          subject: state.selectedSubject!,
                          delay: index * 100,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassDetailPage(
                                  classModel: classModel,
                                  subject: state.selectedSubject!,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: state.classes.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SubjectSelectorDelegate extends SliverPersistentHeaderDelegate {
  final List<SubjectModel> subjects;
  final SubjectModel? selectedSubject;
  final Function(String) onSubjectChanged;

  _SubjectSelectorDelegate({
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SubjectSelector(
        subjects: subjects,
        selectedSubject: selectedSubject,
        onSubjectChanged: onSubjectChanged,
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
