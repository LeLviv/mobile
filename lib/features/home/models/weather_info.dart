import '../../../core/utils/lviv_time.dart';

enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  fog,
  drizzle,
  rain,
  snow,
  thunderstorm,
  unknown,
}

class WeatherInfo {
  final double temperature;
  final double apparentTemperature;
  final int weatherCode;
  final bool isStale;

  const WeatherInfo({
    required this.temperature,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.isStale,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final report = (json['report'] as Map<String, dynamic>?) ?? json;

    return WeatherInfo(
      temperature: (report['current_temperature_celsius'] as num).toDouble(),
      apparentTemperature:
      (report['apparent_temperature_celsius'] as num).toDouble(),
      weatherCode: (report['weather_code'] as num).toInt(),
      isStale: json['is_stale'] as bool? ?? false,
    );
  }

  factory WeatherInfo.fromHourlyJson(Map<String, dynamic> json) {
    final raw = json['reports'] ?? json['report'];
    final reports = (raw as List).cast<Map<String, dynamic>>();
    if (reports.isEmpty) {
      throw const FormatException('Hourly forecast is empty');
    }

    final now = LvivTime.now();
    final current = reports.firstWhere(
          (r) => _isCurrentHour(r['time'].toString(), now),
      orElse: () => reports.first,
    );

    return WeatherInfo(
      temperature: (current['temperature_celsius'] as num).toDouble(),
      apparentTemperature:
      (current['apparent_temperature_celsius'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      isStale: json['is_stale'] as bool? ?? false,
    );
  }

  static bool _isCurrentHour(String time, DateTime now) {
    final match = RegExp(
      r'^(?:(\d{4})-(\d{2})-(\d{2})[T ])?(\d{1,2}):(\d{2})',
    ).firstMatch(time);
    if (match == null) return false;

    final year = match.group(1);
    if (year != null) {
      final sameDay = int.parse(year) == now.year &&
          int.parse(match.group(2)!) == now.month &&
          int.parse(match.group(3)!) == now.day;
      if (!sameDay) return false;
    }

    return int.parse(match.group(4)!) == now.hour;
  }

  int get roundedTemperature => temperature.round();

  WeatherCondition get condition => _conditionFromCode(weatherCode);

  static WeatherCondition _conditionFromCode(int code) {
    switch (code) {
      case 0:
      case 1:
        return WeatherCondition.clear;
      case 2:
        return WeatherCondition.partlyCloudy;
      case 3:
        return WeatherCondition.cloudy;
      case 45:
      case 48:
        return WeatherCondition.fog;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return WeatherCondition.drizzle;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return WeatherCondition.rain;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snow;
      case 95:
      case 96:
      case 97:
      case 99:
        return WeatherCondition.thunderstorm;
      default:
        return WeatherCondition.unknown;
    }
  }
}