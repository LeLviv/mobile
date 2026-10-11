import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const TextField(
                decoration: InputDecoration(
                  hintText: AppStrings.usernameHint,
                  filled: true,
                  fillColor: AppColors.field,
                ),
              ),
              const SizedBox(height: AppDimens.spaceS),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AppStrings.passwordHint,
                  filled: true,
                  fillColor: AppColors.field,
                ),
              ),
              const SizedBox(height: AppDimens.spaceM),
              ElevatedButton(
                onPressed: () {},
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