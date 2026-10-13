import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final message = (username.isEmpty || password.isEmpty)
        ? AppStrings.fillAllFields
        : AppStrings.loginSuccess;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.screenPadding),
          child: Column(
            children: [
              const SizedBox(height: AppDimens.spaceXl),
              const Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  fontSize: AppDimens.titleSize,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppDimens.spaceL),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: AppStrings.usernameHint,
                  filled: true,
                  fillColor: AppColors.field,
                ),
              ),
              const SizedBox(height: AppDimens.spaceS),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: AppStrings.passwordHint,
                  filled: true,
                  fillColor: AppColors.field,
                ),
              ),
              const SizedBox(height: AppDimens.spaceM),
              ElevatedButton(
                onPressed: _onLoginPressed,
                child: const Text(AppStrings.loginButton),
              ),
              _whiteTextButton(AppStrings.forgotPassword),
              OutlinedButton(
                onPressed: () {},
                child: const Text(
                  AppStrings.signInWithGoogle,
                  style: TextStyle(color: AppColors.text),
                ),
              ),
              _whiteTextButton(AppStrings.continueAsGuest),
              _whiteTextButton(AppStrings.register),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whiteTextButton(String label) {
    return TextButton(
      onPressed: () {},
      child: Text(label, style: const TextStyle(color: AppColors.text)),
    );
  }
}