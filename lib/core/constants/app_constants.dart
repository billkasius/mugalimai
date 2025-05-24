class AppConstants {
  static const String appName = 'Mugalim AI';
  static const String appVersion = '1.0.0';

  // Supported subjects
  static const List<String> subjects = [
    'kyrgyz',
    'russian',
    'english',
  ];

  // Supported languages
  static const List<String> supportedLanguages = ['en', 'ru', 'ky'];

  // Storage keys
  static const String userKey = 'user';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String notificationsKey = 'notifications';
  static const String soundNotificationsKey = 'sound_notifications';
  static const String vibrationNotificationsKey = 'vibration_notifications';

  static const String baseUrl = 'http://localhost:8000';
}
