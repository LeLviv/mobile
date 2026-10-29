import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/main_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.login,
    routes: {
      AppRoutes.login: (_) => const LoginScreen(),
      AppRoutes.register: (_) => const RegisterScreen(),
      AppRoutes.home: (_) => const MainScreen(),
    },
  ));
}