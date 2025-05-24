// lib/features/settings/presentation/bloc/settings_state.dart
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
  final bool notificationsEnabled;
  final bool soundNotifications;
  final bool vibrationNotifications;

  const SettingsLoaded({
    required this.locale,
    required this.themeMode,
    this.notificationsEnabled = true,
    this.soundNotifications = true,
    this.vibrationNotifications = true,
  });

  @override
  List<Object> get props => [
    locale,
    themeMode,
    notificationsEnabled,
    soundNotifications,
    vibrationNotifications
  ];

  SettingsLoaded copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? soundNotifications,
    bool? vibrationNotifications,
  }) {
    return SettingsLoaded(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundNotifications: soundNotifications ?? this.soundNotifications,
      vibrationNotifications: vibrationNotifications ?? this.vibrationNotifications,
    );
  }
}
