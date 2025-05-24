import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';
import 'classes_event.dart';
import 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  ClassesBloc() : super(ClassesInitial()) {
    on<LoadClasses>(_onLoadClasses);
    on<SelectSubject>(_onSelectSubject);
    on<SelectClass>(_onSelectClass);
    on<SearchStudents>(_onSearchStudents);
  }

  void _onLoadClasses(LoadClasses event, Emitter<ClassesState> emit) async {
    emit(ClassesLoading());

    try {
      // Загружаем предметы учителя
      final subjectsData = await _databaseHelper.getSubjectsByTeacher(event.teacherId);
      final subjects = subjectsData.map((data) => SubjectModel(
        id: data['id'],
        name: data['name'],
        nameKy: data['name_ky'],
        nameRu: data['name_ru'],
        nameEn: data['name_en'],
        type: SubjectType.values.firstWhere((e) => e.name == data['type']),
        color: Color(data['color_value']),
      )).toList();

      if (subjects.isEmpty) {
        emit(const ClassesError('У вас нет доступных предметов'));
        return;
      }

      // Загружаем классы учителя
      final classesData = await _databaseHelper.getClassesByTeacher(event.teacherId);
      final classes = classesData.map((data) => ClassModel(
        id: data['id'],
        name: data['name'],
        grade: data['grade'],
        letter: data['letter'],
        studentCount: data['student_count'] ?? 0,
        averagePerformance: 0.0, // Будем вычислять отдельно
        students: [], // Загружаем при выборе класса
        teacherId: event.teacherId,
      )).toList();

      emit(ClassesLoaded(
        classes: classes,
        subjects: subjects,
        selectedSubject: subjects.first,
        filteredStudents: [],
        searchQuery: '',
      ));
    } catch (e) {
      emit(ClassesError('Ошибка загрузки данных: $e'));
    }
  }

  void _onSelectSubject(SelectSubject event, Emitter<ClassesState> emit) {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;
      final selectedSubject = currentState.subjects.firstWhere(
            (subject) => subject.id == event.subjectId,
      );

      emit(currentState.copyWith(
        selectedSubject: selectedSubject,
        selectedClass: null,
        filteredStudents: [],
        searchQuery: '',
      ));
    }
  }

  void _onSelectClass(SelectClass event, Emitter<ClassesState> emit) async {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;

      try {
        // Загружаем учеников класса
        final studentsData = await _databaseHelper.getStudentsByClass(event.classId);
        final students = <StudentModel>[];

        for (final studentData in studentsData) {
          // Загружаем средние оценки по выбранному предмету
          final averageGrade = await _databaseHelper.getStudentAverageGrade(
            studentData['id'],
            currentState.selectedSubject!.id,
          );

          final student = StudentModel(
            id: studentData['id'],
            firstName: studentData['first_name'],
            lastName: studentData['last_name'],
            classId: studentData['class_id'],
            subjects: [currentState.selectedSubject!.id],
            averageGrades: {currentState.selectedSubject!.id: averageGrade},
            photoUrl: studentData['photo_url'],
          );

          students.add(student);
        }

        final selectedClass = currentState.classes.firstWhere(
              (cls) => cls.id == event.classId,
        ).copyWith(students: students);

        emit(currentState.copyWith(
          selectedClass: selectedClass,
          filteredStudents: students,
          searchQuery: '',
        ));
      } catch (e) {
        emit(ClassesError('Ошибка загрузки учеников: $e'));
      }
    }
  }

  void _onSearchStudents(SearchStudents event, Emitter<ClassesState> emit) async {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;

      if (currentState.selectedClass == null) return;

      try {
        List<StudentModel> filteredStudents;

        if (event.query.isEmpty) {
          filteredStudents = currentState.selectedClass!.students;
        } else {
          final studentsData = await _databaseHelper.searchStudents(
            currentState.selectedClass!.id,
            event.query,
          );

          filteredStudents = [];
          for (final studentData in studentsData) {
            final averageGrade = await _databaseHelper.getStudentAverageGrade(
              studentData['id'],
              currentState.selectedSubject!.id,
            );

            final student = StudentModel(
              id: studentData['id'],
              firstName: studentData['first_name'],
              lastName: studentData['last_name'],
              classId: studentData['class_id'],
              subjects: [currentState.selectedSubject!.id],
              averageGrades: {currentState.selectedSubject!.id: averageGrade},
              photoUrl: studentData['photo_url'],
            );

            filteredStudents.add(student);
          }
        }

        emit(currentState.copyWith(
          filteredStudents: filteredStudents,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(ClassesError('Ошибка поиска: $e'));
      }
    }
  }
}
