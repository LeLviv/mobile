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
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
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

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.field,
      errorStyle: const TextStyle(color: AppColors.text),
    );
  }

  String? _validateUsername(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.fieldRequired;
    if (text.length < 2) return AppStrings.usernameTooShort;
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.fieldRequired;
    if (!_emailRegex.hasMatch(text)) return AppStrings.emailInvalid;
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return AppStrings.fieldRequired;
    if (text.length < 8) return AppStrings.passwordTooShort;
    return null;
  }

  String? _validateConfirm(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return AppStrings.fieldRequired;
    if (text != _passwordController.text) return AppStrings.passwordsDontMatch;
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

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
          'firstname': _usernameController.text.trim(),
          'lastname': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage(AppStrings.registerSuccess);
        Navigator.pop(context);
      } else {
        debugPrint('Register failed: ${response.statusCode} ${response.body}');
        _showMessage(AppStrings.registerError);
      }
    } catch (e) {
      debugPrint('Register exception: $e');
      if (!mounted) return;
      _showMessage(AppStrings.connectionError);
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
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: _usernameController,
                  validator: _validateUsername,
                  decoration: _decoration(AppStrings.usernameHint),
                ),
                const SizedBox(height: AppDimens.spaceS),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: _decoration(AppStrings.emailHint),
                ),
                const SizedBox(height: AppDimens.spaceS),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  decoration: _decoration(AppStrings.passwordHint),
                ),
                const SizedBox(height: AppDimens.spaceS),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  validator: _validateConfirm,
                  decoration: _decoration(AppStrings.confirmPasswordHint),
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
                OutlinedButton(
                  onPressed: () {}, // TODO: реєстрація через Google
                  child: const Text(
                    AppStrings.registerWithGoogle,
                    style: TextStyle(color: AppColors.text),
                  ),
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
      ),
    );
  }
}