import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannelConfig {
  const NotificationChannelConfig({
    required this.id,
    required this.name,
    this.description = "",
    this.importance = Importance.max,
    this.priority = Priority.high,
  });

  final String id;
  final String name;
  final String description;
  final Importance importance;
  final Priority priority;
}

typedef PushDataHandler = Future<void> Function(Map<String, dynamic> data);

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Track stream subscriptions to prevent duplicate listeners if setupFCM() is re-called.
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;

  static const NotificationChannelConfig defaultChannel =
      NotificationChannelConfig(
        id: 'general_alerts_channel',
        name: "Default Notification Channel",
      );

  Future<void> initializeLocalNotifications({
    void Function(NotificationResponse)? onNotificationTap,
  }) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
    // Create Android High Importance Notification Channel programmatically
    await createChannel(defaultChannel);
  }

  Future<void> createChannel(NotificationChannelConfig channel) async {
    final androidChannel = AndroidNotificationChannel(
      channel.id,
      channel.name,
      description: channel.description,
      importance: channel.importance,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> subscribeToTopic(String topic) async {
    final messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await messaging.getAPNSToken();
      }
      if (apnsToken == null) return;
    }
    await messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  /// Configures Firebase Cloud Messaging listeners and permissions.
  Future<bool> setupFCM({required PushDataHandler onDataReceived}) async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    bool isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (isAuthorized) {
      // Configure foreground presentation for iOS
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Foreground listener
    // Cancel existing subscriptions before attaching new ones.
    await _onMessageSub?.cancel();
    _onMessageSub = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification == null) {
        onDataReceived(message.data);
      }
    });

    // Handle user tapping notification when app is in background
    await _onMessageOpenedAppSub?.cancel();
    _onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {
      // onNotificationTap(message.data);
    });

    // Handle notification launch from terminated state
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   onNotificationTap(initialMessage.data);
      // });
    }
    return isAuthorized;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    NotificationChannelConfig channel = defaultChannel,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: channel.importance,
      priority: channel.priority,
      icon: '@mipmap/ic_launcher',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
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
