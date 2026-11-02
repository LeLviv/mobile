import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../core/widgets/loading_dots.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String? _validateRequired(String? value) {
    if ((value ?? '').trim().isEmpty) return AppStrings.fieldRequired;
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        ApiEndpoints.authenticate,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage(AppStrings.loginSuccess);

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
              (route) => false,
        );
      } else {
        debugPrint('Login failed: ${response.statusCode} ${response.body}');
        _showMessage(AppStrings.loginError);
      }
    } catch (e) {
      debugPrint('Login exception: $e');
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
                        color: AppColors.fieldFill,
                        borderRadius:
                        BorderRadius.circular(AppDimens.langRadius),
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
                  minHeight: MediaQuery.of(context).size.height * 0.5,
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
                            AppStrings.loginTitle,
                            style: TextStyle(
                              fontSize: 44,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: s.w(0.025)),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            validator: _validateRequired,
                            decoration: const InputDecoration(
                              hintText: AppStrings.emailaddress,
                            ),
                          ),
                          SizedBox(height: s.w(0.025)),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: _validateRequired,
                            decoration: const InputDecoration(
                              hintText: AppStrings.passwordHint,
                            ),
                          ),
                          SizedBox(height: s.w(0.04)),
                          SizedBox(
                            width: double.infinity,
                            height: s.w(0.17),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
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
                                  AppStrings.loginButton,
                                  style: TextStyle(
                                    fontSize: s.font(0.1),
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: s.w(0.04)),
                          FractionallySizedBox(
                            widthFactor: 0.55,
                            child: SizedBox(
                              height: s.w(0.12),
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.fieldFill,
                                  foregroundColor: AppColors.primary,
                                  shape: const StadiumBorder(),
                                ).copyWith(
                                  side: WidgetStateProperty.resolveWith(
                                        (states) {
                                      if (states
                                          .contains(WidgetState.pressed) ||
                                          states
                                              .contains(WidgetState.focused)) {
                                        return const BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        );
                                      }
                                      return BorderSide.none;
                                    },
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppStrings.loginWithGoogle,
                                    style: TextStyle(fontSize: s.font(0.04)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: s.w(0.04)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
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
                                        '${AppStrings.noAccountQuestion}\n'
                                            '${AppStrings.noAccountTap} ',
                                      ),
                                      TextSpan(
                                        text: AppStrings.noAccountRegister,
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