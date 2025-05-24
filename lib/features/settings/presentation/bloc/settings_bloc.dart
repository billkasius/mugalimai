import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart' as di;
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs = di.sl<SharedPreferences>();

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeTheme>(_onChangeTheme);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(SettingsLoading());

    final languageCode = _prefs.getString(AppConstants.languageKey) ?? 'ru';
    final themeIndex = _prefs.getInt(AppConstants.themeKey) ?? 0;

    final locale = Locale(languageCode);
    final themeMode = ThemeMode.values[themeIndex];

    emit(SettingsLoaded(locale: locale, themeMode: themeMode));
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      _prefs.setString(AppConstants.languageKey, event.locale.languageCode);
      emit(currentState.copyWith(locale: event.locale));
    }
  }

  void _onChangeTheme(ChangeTheme event, Emitter<SettingsState> emit) {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      _prefs.setInt(AppConstants.themeKey, event.themeMode.index);
      emit(currentState.copyWith(themeMode: event.themeMode));
    }
  }
}
