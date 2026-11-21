import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

abstract final class LvivTime {
  static const _zone = 'Europe/Kyiv';
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    _initialized = true;
  }

  static tz.TZDateTime now() {
    init();
    return tz.TZDateTime.now(tz.getLocation(_zone));
  }
}