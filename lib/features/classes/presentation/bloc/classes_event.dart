// lib/features/classes/presentation/bloc/classes_event.dart
import 'package:equatable/equatable.dart';

abstract class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object> get props => [];
}

class LoadClasses extends ClassesEvent {}

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
