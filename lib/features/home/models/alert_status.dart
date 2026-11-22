enum AlertStatus {
  none,
  yellow,
  red,
  unknown;

  static AlertStatus parse(String raw) {
    final value = raw.trim().replaceAll('"', '').toUpperCase();
    return AlertStatus.values.firstWhere(
          (status) => status.name.toUpperCase() == value,
      orElse: () => AlertStatus.unknown,
    );
  }

  bool get isAlarm => this == AlertStatus.red || this == AlertStatus.yellow;
}