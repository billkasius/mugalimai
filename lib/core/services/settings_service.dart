// lib/core/services/settings_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';
  static const String _notificationsKey = 'notifications';
  static const String _soundNotificationsKey = 'sound_notifications';
  static const String _vibrationNotificationsKey = 'vibration_notifications';

  late SharedPreferences _prefs;

  Locale _locale = const Locale('ru');
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _soundNotifications = true;
  bool _vibrationNotifications = true;

  // Getters
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundNotifications => _soundNotifications;
  bool get vibrationNotifications => _vibrationNotifications;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final languageCode = _prefs.getString(_languageKey) ?? 'ru';
    _locale = Locale(languageCode);

    final themeIndex = _prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;
    _soundNotifications = _prefs.getBool(_soundNotificationsKey) ?? true;
    _vibrationNotifications = _prefs.getBool(_vibrationNotificationsKey) ?? true;

    notifyListeners();
  }

  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _prefs.setInt(_themeKey, themeMode.index);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs.setBool(_notificationsKey, enabled);
    notifyListeners();
  }

  Future<void> setSoundNotifications(bool enabled) async {
    _soundNotifications = enabled;
    await _prefs.setBool(_soundNotificationsKey, enabled);
    notifyListeners();
  }

  Future<void> setVibrationNotifications(bool enabled) async {
    _vibrationNotifications = enabled;
    await _prefs.setBool(_vibrationNotificationsKey, enabled);
    notifyListeners();
  }
}
