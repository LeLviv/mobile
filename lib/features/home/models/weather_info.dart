import 'package:timezone/timezone.dart' as tz;

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/lviv_time.dart';
import '../data/weather_advice_table.dart';

enum WeatherCondition {
  clear(
    codes: [0, 1],
    title: AppStrings.weatherClear,
    adviceCategory: AdviceCategory.sunny,
  ),
  partlyCloudy(
    codes: [2],
    title: AppStrings.weatherPartlyCloudy,
    adviceCategory: AdviceCategory.sunny,
  ),
  cloudy(
    codes: [3],
    title: AppStrings.weatherCloudy,
    adviceCategory: AdviceCategory.cloudy,
  ),
  fog(
    codes: [45, 48],
    title: AppStrings.weatherFog,
    adviceCategory: AdviceCategory.cloudy,
  ),
  drizzle(
    codes: [51, 53, 55, 56, 57],
    title: AppStrings.weatherDrizzle,
    adviceCategory: AdviceCategory.rain,
  ),
  rain(
    codes: [61, 63, 65, 66, 67, 80, 81, 82],
    title: AppStrings.weatherRain,
    adviceCategory: AdviceCategory.rain,
  ),
  snow(
    codes: [71, 73, 75, 77, 85, 86],
    title: AppStrings.weatherSnow,
    adviceCategory: AdviceCategory.snow,
  ),
  thunderstorm(
    codes: [95, 96, 97, 99],
    title: AppStrings.weatherThunderstorm,
    adviceCategory: AdviceCategory.rain,
  ),
  unknown(
    codes: [],
    title: AppStrings.weatherUnknown,
    adviceCategory: AdviceCategory.cloudy,
  );

  final List<int> codes;

  final String title;

  final AdviceCategory adviceCategory;

  const WeatherCondition({
    required this.codes,
    required this.title,
    required this.adviceCategory,
  });

  static WeatherCondition fromCode(int code) {
    return WeatherCondition.values.firstWhere(
          (condition) => condition.codes.contains(code),
      orElse: () => WeatherCondition.unknown,
    );
  }
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
    final report = json['report'] is Map<String, dynamic>
        ? json['report'] as Map<String, dynamic>
        : json;

    return WeatherInfo(
      temperature: _asDouble(
        report['current_temperature_celsius'],
        'current_temperature_celsius',
      ),
      apparentTemperature: _asDouble(
        report['apparent_temperature_celsius'],
        'apparent_temperature_celsius',
      ),
      weatherCode: _asInt(report['weather_code'], 'weather_code'),
      isStale: json['is_stale'] == true,
    );
  }

  factory WeatherInfo.fromHourlyJson(Map<String, dynamic> json) {
    final reports = _asMapList(json['reports'] ?? json['report'], 'reports');
    if (reports.isEmpty) {
      throw const FormatException('Hourly forecast is empty');
    }

    final now = LvivTime.now();
    final current = reports.firstWhere(
          (r) => _isSameHour(r['time'].toString(), now),
      orElse: () => reports.first,
    );

    return WeatherInfo(
      temperature: _asDouble(
        current['temperature_celsius'],
        'temperature_celsius',
      ),
      apparentTemperature: _asDouble(
        current['apparent_temperature_celsius'],
        'apparent_temperature_celsius',
      ),
      weatherCode: _asInt(current['weather_code'], 'weather_code'),
      isStale: json['is_stale'] == true,
    );
  }

  static bool _isSameHour(String time, tz.TZDateTime now) {
    final parsed = DateTime.tryParse(time);

    if (parsed != null) {
      final lviv = parsed.isUtc || _hasOffset(time)
          ? tz.TZDateTime.from(parsed, now.location)
          : tz.TZDateTime(
        now.location,
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
      );
      return lviv.year == now.year &&
          lviv.month == now.month &&
          lviv.day == now.day &&
          lviv.hour == now.hour;
    }

    final match = RegExp(r'^(\d{1,2}):\d{2}$').firstMatch(time.trim());
    return match != null && int.parse(match.group(1)!) == now.hour;
  }

  static bool _hasOffset(String time) =>
      RegExp(r'([+-]\d{2}:?\d{2}|Z)$').hasMatch(time.trim());

  int get roundedTemperature => temperature.round();

  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);
}

List<Map<String, dynamic>> _asMapList(Object? value, String field) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().toList();
  }
  throw FormatException('Field "$field" must be a list, got: $value');
}

double _asDouble(Object? value, String field) {
  if (value is num) return value.toDouble();
  throw FormatException('Field "$field" must be a number, got: $value');
}

int _asInt(Object? value, String field) {
  if (value is num) return value.toInt();
  throw FormatException('Field "$field" must be a number, got: $value');
}