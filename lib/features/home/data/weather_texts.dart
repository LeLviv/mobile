import '../../../core/constants/app_strings.dart';
import '../models/weather_info.dart';
import 'weather_advice_table.dart';

abstract final class WeatherTexts {
  static String advice(WeatherInfo weather) {
    final t = weather.roundedTemperature;
    var category = weather.condition.adviceCategory;

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
}