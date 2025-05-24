class ApiConstants {
  static const String baseUrl = 'https://your-backend-url.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String checkHomeworkEndpoint = '/ai/check-homework';
  static const String generateTestEndpoint = '/ai/generate-test';
  static const String generateHomeworkEndpoint = '/ai/generate-homework';

  // Request timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
