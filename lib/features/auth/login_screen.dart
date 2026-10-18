import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Будь ласка, заповніть всі поля')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = ApiEndpoints.authenticate;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phone,
          'password': password,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Успішний вхід!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка авторизації: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка з\'єднання з сервером: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
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
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text(AppStrings.loginButton),
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
              _whiteTextButton(
                AppStrings.register,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whiteTextButton(String label, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed ?? () {},
      child: Text(label, style: const TextStyle(color: AppColors.text)),
    );
  }
}