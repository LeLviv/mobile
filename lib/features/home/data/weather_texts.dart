import '../../../core/constants/app_strings.dart';
import '../models/weather_info.dart';
import 'weather_advice_table.dart';

abstract final class WeatherTexts {
  static String title(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return AppStrings.weatherClear;
      case WeatherCondition.partlyCloudy:
        return AppStrings.weatherPartlyCloudy;
      case WeatherCondition.cloudy:
        return AppStrings.weatherCloudy;
      case WeatherCondition.fog:
        return AppStrings.weatherFog;
      case WeatherCondition.drizzle:
        return AppStrings.weatherDrizzle;
      case WeatherCondition.rain:
        return AppStrings.weatherRain;
      case WeatherCondition.snow:
        return AppStrings.weatherSnow;
      case WeatherCondition.thunderstorm:
        return AppStrings.weatherThunderstorm;
      case WeatherCondition.unknown:
        return AppStrings.weatherUnknown;
    }
  }

  static String advice(WeatherInfo weather) {
    final t = weather.roundedTemperature;
    var category = _category(weather.condition);

    if (category == AdviceCategory.rain && t < 0) {
      category = AdviceCategory.snow;
    }
    if (category == AdviceCategory.snow && t >= 5) {
      category = AdviceCategory.rain;
    }

    for (final entry in WeatherAdviceTable.entries) {
      if (entry.matches(category, t)) return entry.text;
    }
    return AppStrings.adviceFallback;
  }

  static AdviceCategory _category(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.partlyCloudy:
        return AdviceCategory.sunny;
      case WeatherCondition.cloudy:
      case WeatherCondition.fog:
      case WeatherCondition.unknown:
        return AdviceCategory.cloudy;
      case WeatherCondition.snow:
        return AdviceCategory.snow;
      case WeatherCondition.drizzle:
      case WeatherCondition.rain:
      case WeatherCondition.thunderstorm:
        return AdviceCategory.rain;
    }
  }
}