import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_location.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/token_storage.dart';
import '../models/weather_info.dart';

class WeatherRepository {
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;
  final TokenStorage _tokenStorage;
  final bool _ownsClient;

  WeatherRepository({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null,
        _tokenStorage = tokenStorage ?? TokenStorage();

  void dispose() {
    if (_ownsClient) _client.close();
  }

  Future<WeatherInfo> fetchCurrent() async {
    final uri = ApiEndpoints.weatherHourly(AppLocation.lvivRegion);
    final weatherToken = await _tokenStorage.readWeatherToken();
    final authToken = await _tokenStorage.read();
    final token = (weatherToken != null && weatherToken.isNotEmpty)
        ? weatherToken
        : authToken;

    final response = await _client.get(
      uri,
      headers: {
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      debugPrint(
        'Weather request failed: ${response.statusCode} ${response.body}',
      );
      throw Exception('Weather request failed: ${response.statusCode}');
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return WeatherInfo.fromHourlyJson(json);
  }
}