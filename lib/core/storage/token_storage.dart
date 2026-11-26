import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _authTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _weatherTokenKey = 'weather_api_token';
  static const _airRaidTokenKey = 'air_raid_api_token';
  static const _newsTokenKey = 'news_api_token';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // --- Auth JWT Tokens ---

  /// Saves the primary JWT access token.
  Future<void> save(String token) =>
      _storage.write(key: _authTokenKey, value: token);

  /// Reads the primary JWT access token.
  Future<String?> read() => _storage.read(key: _authTokenKey);

  /// Deletes the primary JWT access token.
  Future<void> clear() => _storage.delete(key: _authTokenKey);

  /// Checks if a valid auth token is stored.
  Future<bool> hasToken() async {
    final token = await read();
    return token != null && token.isNotEmpty;
  }

  /// Saves both access and refresh tokens.
  Future<void> saveAuthTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await save(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await saveRefreshToken(refreshToken);
    } else {
      await clearRefreshToken();
    }
  }

  // --- Refresh Token ---

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearRefreshToken() => _storage.delete(key: _refreshTokenKey);

  // --- Weather API Token ---

  Future<void> saveWeatherToken(String token) =>
      _storage.write(key: _weatherTokenKey, value: token);

  Future<String?> readWeatherToken() => _storage.read(key: _weatherTokenKey);

  Future<void> clearWeatherToken() => _storage.delete(key: _weatherTokenKey);

  // --- Air Raid API Token ---

  Future<void> saveAirRaidToken(String token) =>
      _storage.write(key: _airRaidTokenKey, value: token);

  Future<String?> readAirRaidToken() => _storage.read(key: _airRaidTokenKey);

  Future<void> clearAirRaidToken() => _storage.delete(key: _airRaidTokenKey);

  // --- News API Token ---

  Future<void> saveNewsToken(String token) =>
      _storage.write(key: _newsTokenKey, value: token);

  Future<String?> readNewsToken() => _storage.read(key: _newsTokenKey);

  Future<void> clearNewsToken() => _storage.delete(key: _newsTokenKey);

  // --- General cleanup ---

  /// Clears all stored tokens.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Returns `true` when [token] is a JWT whose `exp` claim is in the past.
  static bool isJwtExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return false;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(normalized))) as Object?;
      if (payload is! Map<String, dynamic>) return false;
      final exp = payload['exp'];
      if (exp is! num) return false;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return false;
    }
  }
}
