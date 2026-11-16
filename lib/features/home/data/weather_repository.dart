import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_location.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/token_storage.dart';
import '../models/weather_info.dart';

class WeatherRepository {
  static const _timeout = Duration(seconds: 10);

  Future<WeatherInfo> fetchCurrent() async {
    final uri = ApiEndpoints.weatherHourly(AppLocation.lvivRegion);
    final token = await TokenStorage.read();

    final response = await http.get(
      uri,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ).timeout(_timeout);

    debugPrint('Weather request: $uri');
    debugPrint('Weather response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Weather request failed: ${response.statusCode}');
    }

    final json =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return WeatherInfo.fromHourlyJson(json);
  }
}