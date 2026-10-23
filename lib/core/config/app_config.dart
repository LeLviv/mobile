class AppConfig {
  AppConfig._();

  static const String _env = String.fromEnvironment('ENV');
  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');

  static bool get isDev => _env == 'dev';
  static bool get isProd => _env == 'prod';

  static String get apiBaseUrl {
    assert(
    _baseUrl.isNotEmpty,
    'API_BASE_URL is not configured! Please provide environment variables via: '
        '--dart-define-from-file=.env.dev',
    );
    return _baseUrl;
  }
}