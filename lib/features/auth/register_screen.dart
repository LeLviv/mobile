import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (username.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showMessage(AppStrings.fillAllFieldsRegister);
      return;
    }

    if (username.length < 2) {
      _showMessage(AppStrings.usernameTooShort);
      return;
    }

    if (phone.length != 12) {
      _showMessage(AppStrings.phoneInvalid);
      return;
    }

    if (password.length < 8) {
      _showMessage(AppStrings.passwordTooShort);
      return;
    }

    if (password != confirm) {
      _showMessage(AppStrings.passwordsDontMatch);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        ApiEndpoints.register,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstname': username,
          'lastname': username,
          'phoneNumber': phone,
          'password': password,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage(AppStrings.registerSuccess);
        Navigator.pop(context);
      } else {
        _showMessage('Помилка реєстрації: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Помилка з\'єднання з сервером: $e');
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
                AppStrings.registerTitle,
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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: AppStrings.phoneHint,
                  filled: true,
                  fillColor: AppColors.field,
                ),
              ),
              const SizedBox(height: AppDimens.spaceS),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: AppStrings.emailHint,
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
              const SizedBox(height: AppDimens.spaceS),

              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: AppStrings.confirmPasswordHint,
                  filled: true,
                  fillColor: AppColors.field,
                ),
              ),
              const SizedBox(height: AppDimens.spaceM),

              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text(AppStrings.registerButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  AppStrings.haveAccount,
                  style: TextStyle(color: AppColors.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}