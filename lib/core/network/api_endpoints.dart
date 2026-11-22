import '../config/app_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get _baseUrl => AppConfig.apiBaseUrl;

  static Uri get authenticate => Uri.parse('$_baseUrl/auth/authenticate');
  static Uri get register => Uri.parse('$_baseUrl/auth/register');

  static Uri weatherDaily(String region) => Uri.parse('$_baseUrl/weather/daily')
          .replace(queryParameters: {'region': region});

  static Uri weatherHourly(String region) => Uri.parse('$_baseUrl/weather/hourly')
          .replace(queryParameters: {'region': region});

  static Uri get airRaidStatus => Uri.parse('$_baseUrl/air-raid');
}