// lib/features/classes/presentation/bloc/classes_state.dart
import 'package:equatable/equatable.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/student_model.dart';

abstract class ClassesState extends Equatable {
  const ClassesState();

  @override
  List<Object?> get props => [];
}

class ClassesInitial extends ClassesState {}

class ClassesLoading extends ClassesState {}

class ClassesLoaded extends ClassesState {
  final List<ClassModel> classes;
  final List<StudentModel> students;
  final String searchQuery;

  const ClassesLoaded({
    required this.classes,
    this.students = const [],
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [classes, students, searchQuery];

  ClassesLoaded copyWith({
    List<ClassModel>? classes,
    List<StudentModel>? students,
    String? searchQuery,
  }) {
    return ClassesLoaded(
      classes: classes ?? this.classes,
      students: students ?? this.students,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ClassesError extends ClassesState {
  final String message;

  const ClassesError(this.message);

  @override
  List<Object> get props => [message];
}
