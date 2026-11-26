import 'package:flutter/gestures.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/core/notifications/notification_service.dart';
import 'package:mobile/features/air_raid/air_raid_notifications.dart';
import 'package:mobile/firebase_options.dart';

import 'core/constants/app_routes.dart';
import 'core/network/user_info_service.dart';
import 'core/profile/profile_controller.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/lviv_time.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/main_screen.dart';
import 'features/settings/user_settings_screen.dart';

Future<void> routePushPayload(Map<String, dynamic> data) async {
  switch (data['type']?.toString()) {
    case 'AIR':
      await AirRaidNotificationService.instance.handleDataPayload(data);
      break;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.instance.initializeLocalNotifications();
  await routePushPayload(message.data);
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

Future<String> _resolveInitialRoute() async {
  final tokenStorage = TokenStorage();
  try {
    final token = await tokenStorage.read();
    if (token == null || token.isEmpty) {
      return AppRoutes.login;
    }

    if (TokenStorage.isJwtExpired(token)) {
      await tokenStorage.clearAll();
      await ProfileController.instance.clear();
      return AppRoutes.login;
    }

    await ProfileController.instance.restoreProfile();
    ProfileController.instance.setToken(token);

    final usernameResult = await UserInfoService.fetchUsername(token);
    if (usernameResult.status == UsernameFetchStatus.unauthorized) {
      await tokenStorage.clearAll();
      await ProfileController.instance.clear();
      return AppRoutes.login;
    }

    if (ProfileController.instance.name.isEmpty &&
        usernameResult.username != null &&
        usernameResult.username!.isNotEmpty) {
      ProfileController.instance.setName(usernameResult.username!);
    }

    return AppRoutes.home;
  } catch (e) {
    debugPrint('Session restore error: $e');
    return AppRoutes.login;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LvivTime.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);
  try {
    final notificationService = NotificationService.instance;
    await notificationService.initializeLocalNotifications();
    final authorized = await notificationService.setupFCM(
      onDataReceived: routePushPayload,
    );
    if (authorized) {
      await AirRaidNotificationService.instance.syncSubscription();
    }
  } catch (e, stackTrace) {
    debugPrint('Notification initialization failed: $e\n$stackTrace');
  }

  final initialRoute = await _resolveInitialRoute();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      scrollBehavior: AppScrollBehavior(),
      initialRoute: initialRoute,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const MainScreen(),
        AppRoutes.usersettings: (_) => const UserSettingsScreen(),
      },
    ),
  );
}
