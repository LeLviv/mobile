import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/token_storage.dart';
import '../models/alert_status.dart';

class AlertRepository {
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;
  final TokenStorage _tokenStorage;

  final bool _ownsClient;

  AlertRepository({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null,
        _tokenStorage = tokenStorage ?? TokenStorage();

  Future<AlertStatus> fetchStatus() async {
    final airRaidToken = await _tokenStorage.readAirRaidToken();
    final authToken = await _tokenStorage.read();
    final token = (airRaidToken != null && airRaidToken.isNotEmpty)
        ? airRaidToken
        : authToken;

    final response = await _client.get(
      ApiEndpoints.airRaidStatus,
      headers: {
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Alert request failed: ${response.statusCode}');
    }

    final status = AlertStatus.parse(utf8.decode(response.bodyBytes));
    if (status == AlertStatus.unknown) {
      throw const FormatException('Alert status is unknown');
    }
    return status;
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}