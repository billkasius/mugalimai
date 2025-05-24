import 'package:equatable/equatable.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/student_model.dart';
import '../../../../core/models/subject_model.dart';

abstract class ClassesState extends Equatable {
  const ClassesState();

  @override
  List<Object?> get props => [];
}

class ClassesInitial extends ClassesState {}

class ClassesLoading extends ClassesState {}

class ClassesLoaded extends ClassesState {
  final List<ClassModel> classes;
  final List<SubjectModel> subjects;
  final SubjectModel? selectedSubject;
  final ClassModel? selectedClass;
  final List<StudentModel> filteredStudents;
  final String searchQuery;

  const ClassesLoaded({
    required this.classes,
    required this.subjects,
    this.selectedSubject,
    this.selectedClass,
    required this.filteredStudents,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    classes,
    subjects,
    selectedSubject,
    selectedClass,
    filteredStudents,
    searchQuery,
  ];

  ClassesLoaded copyWith({
    List<ClassModel>? classes,
    List<SubjectModel>? subjects,
    SubjectModel? selectedSubject,
    ClassModel? selectedClass,
    List<StudentModel>? filteredStudents,
    String? searchQuery,
  }) {
    return ClassesLoaded(
      classes: classes ?? this.classes,
      subjects: subjects ?? this.subjects,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      selectedClass: selectedClass ?? this.selectedClass,
      filteredStudents: filteredStudents ?? this.filteredStudents,
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
