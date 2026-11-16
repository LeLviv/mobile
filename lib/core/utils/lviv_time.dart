abstract final class LvivTime {
  static DateTime now() {
    final utc = DateTime.now().toUtc();
    return utc.add(Duration(hours: _isSummerTime(utc) ? 3 : 2));
  }

  static bool _isSummerTime(DateTime utc) {
    final start = DateTime.utc(utc.year, 3, _lastSunday(utc.year, 3), 1);
    final end = DateTime.utc(utc.year, 10, _lastSunday(utc.year, 10), 1);
    return !utc.isBefore(start) && utc.isBefore(end);
  }

  static int _lastSunday(int year, int month) {
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    final weekday = DateTime.utc(year, month, lastDay).weekday;
    return lastDay - (weekday % 7);
  }
}