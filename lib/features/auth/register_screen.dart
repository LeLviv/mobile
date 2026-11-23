import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../core/widgets/loading_dots.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(hintText: hint);
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
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
    final s = AppScale(context);
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.headerRed,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/register_header.png',
                  width: w,
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.fieldSolid,
                        borderRadius: BorderRadius.circular(
                          AppDimens.langRadius,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        AppStrings.languageCode,
                        style: TextStyle(
                          fontFamily: 'LibreFranklin',
                          color: AppColors.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -1),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                color: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.screenPadding,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            AppStrings.registerTitle,
                            style: TextStyle(
                              fontSize: 44,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceS),
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
                            decoration: _decoration(
                              AppStrings.confirmPasswordHint,
                            ),
                          ),
                          SizedBox(height: s.w(0.04)),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: SizedBox(
                              height: s.w(0.12),
                              child: OutlinedButton(
                                onPressed: () {},
                                style:
                                    OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.fieldFill,
                                      foregroundColor: AppColors.primary,
                                      shape: const StadiumBorder(),
                                    ).copyWith(
                                      side: WidgetStateProperty.resolveWith((
                                        states,
                                      ) {
                                        if (states.contains(
                                              WidgetState.pressed,
                                            ) ||
                                            states.contains(
                                              WidgetState.focused,
                                            )) {
                                          return const BorderSide(
                                            color: AppColors.primary,
                                            width: 2,
                                          );
                                        }
                                        return BorderSide.none;
                                      }),
                                    ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppStrings.registerWithGoogle,
                                    style: TextStyle(fontSize: s.font(0.04)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: s.w(0.04)),
                          SizedBox(
                            width: double.infinity,
                            height: s.w(0.17),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                disabledBackgroundColor: AppColors.blueDark,
                                foregroundColor: AppColors.text,
                                shape: const StadiumBorder(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: s.w(0.04),
                                ),
                              ),
                              child: _isLoading
                                  ? const LoadingDots()
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppStrings.registerButton,
                                        style: TextStyle(fontSize: s.font(0.1)),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: s.w(0.04)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontSize: s.font(0.05),
                                      color: AppColors.loginAccent,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text:
                                            '${AppStrings.haveAccountQuestion}\n'
                                            '${AppStrings.haveAccountTap} ',
                                      ),
                                      TextSpan(
                                        text: AppStrings.haveAccountLogin,
                                        style: const TextStyle(
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
