import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_endpoints.dart';

enum UsernameFetchStatus { ok, unauthorized, error }

class UsernameFetchResult {
  final UsernameFetchStatus status;
  final String? username;

  const UsernameFetchResult(this.status, [this.username]);
}

class UserInfoService {
  UserInfoService._();

  static const Duration _timeout = Duration(seconds: 5);

  /// Fetches the current user's display name using the given JWT [token].
  static Future<UsernameFetchResult> fetchUsername(
    String token, {
    http.Client? client,
  }) async {
    final ownsClient = client == null;
    final httpClient = client ?? http.Client();

    try {
      final response = await httpClient
          .get(
            ApiEndpoints.username,
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final raw = utf8.decode(response.bodyBytes).trim();
        return UsernameFetchResult(
          UsernameFetchStatus.ok,
          _parseUsername(raw),
        );
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('Username fetch unauthorized: ${response.statusCode}');
        return const UsernameFetchResult(UsernameFetchStatus.unauthorized);
      }

      debugPrint('Username fetch failed: ${response.statusCode}');
      return const UsernameFetchResult(UsernameFetchStatus.error);
    } catch (e) {
      debugPrint('Username fetch error: $e');
      return const UsernameFetchResult(UsernameFetchStatus.error);
    } finally {
      if (ownsClient) httpClient.close();
    }
  }

  static String? _parseUsername(String raw) {
    if (raw.isEmpty) return null;
    if (raw.startsWith('{') || raw.startsWith('"')) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is String) {
          final trimmed = decoded.trim();
          return trimmed.isEmpty ? null : trimmed;
        }
        if (decoded is Map<String, dynamic>) {
          final value =
              (decoded['username'] ?? decoded['name'])?.toString().trim();
          return (value != null && value.isNotEmpty) ? value : null;
        }
      } catch (_) {
        // Fall back to raw text if the body is not valid JSON.
      }
    }
    return raw;
  }
}
