import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/app_strings.dart';
import 'package:mobile/core/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirRaidNotificationService {
  AirRaidNotificationService._internal();

  static final AirRaidNotificationService instance =
      AirRaidNotificationService._internal();

  final _notificationService = NotificationService.instance;

  static const String _airAlertPreferenceKey = 'notifications_air_raid_enabled';
  static const String _airAlertTopic = 'air_raid_alert';
  static const int notificationId = 1;

  static const _channel = NotificationChannelConfig(
    id: 'air_raid_alerts_channel',
    name: 'Air Raid Alerts',
    description: 'Air Raid Alert Channel with high priority',
  );

  Future<bool> isAirAlertEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Ensures background isolate reads the latest value
    return prefs.getBool(_airAlertPreferenceKey) ?? true; // Default is true
  }

  Future<void> setAirAlertEnabled(bool enabled) async {
    if (enabled) {
      await _notificationService.subscribeToTopic(_airAlertTopic);
    } else {
      await _notificationService.unsubscribeFromTopic(_airAlertTopic);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_airAlertPreferenceKey, enabled);
  }

  Future<void> syncSubscription() async {
    if (await isAirAlertEnabled()) {
      await _notificationService.subscribeToTopic(_airAlertTopic);
    }
  }

  Future<void> handleDataPayload(Map<String, dynamic> data) async {
    if (!await isAirAlertEnabled()) return;

    final String? status = data['status']?.toString();
    final String? time = data['time']?.toString();

    await _notificationService.createChannel(_channel);

    final trimmedTime = time?.trim();
    DateTime now = DateTime.now();
    String displayTime = (trimmedTime != null && trimmedTime.isNotEmpty)
        ? trimmedTime
        : '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final String title;
    final String body;
    switch (status) {
      case 'RED':
        title = AppStrings.alertActive;
        body = AppStrings.alertRed;
        break;
      case 'YELLOW':
        title = AppStrings.alertActive;
        body = AppStrings.alertYellow;
        break;
      case 'NONE':
        title = AppStrings.alertClear;
        body = AppStrings.alertNone;
        break;
      default:
        debugPrint('WARNING: Received invalid air raid status');
        return;
    }

    await _notificationService.showNotification(
      id: notificationId,
      title: '$displayTime $title',
      channel: _channel,
      body: body,
    );
  }
}
