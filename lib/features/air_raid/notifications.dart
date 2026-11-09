import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/core/constants/app_strings.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.instance.initializeLocalNotifications();
  NotificationService.instance.handleDataPayload(message.data);
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'air_raid_alerts_channel';
  static const String _channelName = 'Air Raid Alerts';

  Future<void> initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification click action if needed
      },
    );

    // Create Android High Importance Notification Channel programmatically
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Configures Firebase Cloud Messaging listeners and permissions.
  Future<void> setupFCM() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Configure foreground presentation for iOS
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await messaging.subscribeToTopic('air_raid_alert');
    }

    // Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleDataPayload(message.data);
    });

    // Handle user tapping notification when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleDataPayload(message.data);
    });

    // Handle notification launch from terminated state
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      handleDataPayload(initialMessage.data);
    }
  }

  void handleDataPayload(Map<String, dynamic> data) {
    final String? type = data['type']?.toString();
    final String? status = data['status']?.toString();
    final String? time = data['time']?.toString();

    String title = AppStrings.alertActive;
    String body = AppStrings.alertClear;

    if (type == 'AIR') {
      switch (status) {
        case 'RED':
          body = AppStrings.alertRed;
          break;
        case 'YELLOW':
          body = AppStrings.alertYellow;
          break;
        default:
          title = AppStrings.alertClear;
          body = AppStrings.alertNone;
          break;
      }
    }

    showCustomNotification(
      id: 1, // Using fixed ID updates existing alert rather than stacking duplicates
      title: '$time $title',
      body: body,
    );
  }

  Future<void> showCustomNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }
}