import 'package:equatable/equatable.dart';

abstract class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object> get props => [];
}

class LoadClasses extends ClassesEvent {
  final String teacherId;

  const LoadClasses(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}

class SelectSubject extends ClassesEvent {
  final String subjectId;

  const SelectSubject(this.subjectId);

  @override
  List<Object> get props => [subjectId];
}

class SelectClass extends ClassesEvent {
  final String classId;

  const SelectClass(this.classId);

  @override
  List<Object> get props => [classId];
}

class SearchStudents extends ClassesEvent {
  final String query;

  const SearchStudents(this.query);

  @override
  List<Object> get props => [query];
}
