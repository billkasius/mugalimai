import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Locale locale;
  final ThemeMode themeMode;

  const SettingsLoaded({
    required this.locale,
    required this.themeMode,
  });

  @override
  List<Object> get props => [locale, themeMode];

  SettingsLoaded copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return SettingsLoaded(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
