// lib/features/settings/presentation/bloc/settings_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final Locale locale;

  const ChangeLanguage(this.locale);

  @override
  List<Object> get props => [locale];
}

class ChangeTheme extends SettingsEvent {
  final ThemeMode themeMode;

  const ChangeTheme(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

// Новые события для уведомлений
class ToggleNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ToggleSoundNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleSoundNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ToggleVibrationNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleVibrationNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}
