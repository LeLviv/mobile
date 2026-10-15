import '../config/app_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get _baseUrl => AppConfig.apiBaseUrl;

  static Uri get authenticate => Uri.parse('$_baseUrl/auth/authenticate');
  static Uri get register => Uri.parse('$_baseUrl/auth/register');
}