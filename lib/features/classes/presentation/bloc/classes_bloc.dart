// lib/features/classes/presentation/bloc/classes_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/mock_data_service.dart';
import 'classes_event.dart';
import 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final MockDataService _mockDataService = MockDataService();

  ClassesBloc() : super(ClassesInitial()) {
    on<LoadClasses>(_onLoadClasses);
    on<SelectClass>(_onSelectClass);
    on<SearchStudents>(_onSearchStudents);
  }

  void _onLoadClasses(LoadClasses event, Emitter<ClassesState> emit) async {
    emit(ClassesLoading());

    try {
      final classes = await _mockDataService.getClasses();
      emit(ClassesLoaded(classes: classes));
    } catch (e) {
      emit(ClassesError('Ошибка загрузки: $e'));
    }
  }

  void _onSelectClass(SelectClass event, Emitter<ClassesState> emit) async {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;

      try {
        final students = await _mockDataService.getStudentsByClass(event.classId);
        emit(currentState.copyWith(students: students, searchQuery: ''));
      } catch (e) {
        emit(ClassesError('Ошибка загрузки учеников: $e'));
      }
    }
  }

  void _onSearchStudents(SearchStudents event, Emitter<ClassesState> emit) {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;

      if (event.query.isEmpty) {
        // Показываем всех учеников
        emit(currentState.copyWith(searchQuery: ''));
      } else {
        // Фильтруем учеников
        final filteredStudents = currentState.students.where((student) {
          final fullName = '${student.firstName} ${student.lastName}'.toLowerCase();
          return fullName.contains(event.query.toLowerCase());
        }).toList();

        emit(currentState.copyWith(students: filteredStudents, searchQuery: event.query));
      }
    }
  }
}
