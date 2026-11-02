import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

abstract final class AppTheme {
  static const _fontFamily = 'Neucha';

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.fieldRadiusPill),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static ButtonStyle _button({
    required Color background,
    required Color foreground,
    required double fontSize,
    required EdgeInsets padding,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      elevation: const WidgetStatePropertyAll(4),
      shadowColor: const WidgetStatePropertyAll(Colors.black54),
      side: const WidgetStatePropertyAll(BorderSide.none),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
      ),
      padding: WidgetStatePropertyAll(padding),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontFamily: _fontFamily, fontSize: fontSize),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.background,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        hintStyle: const TextStyle(
          color: AppColors.background,
          fontSize: AppDimens.hintSize,
        ),
        errorStyle: const TextStyle(color: AppColors.primary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.fieldPaddingH,
          vertical: AppDimens.fieldPaddingV,
        ),
        border: _border(Colors.transparent, 0),
        enabledBorder: _border(Colors.transparent, 0),
        focusedBorder: _border(AppColors.primary, 2),
        errorBorder: _border(AppColors.primary, 1),
        focusedErrorBorder: _border(AppColors.primary, 2),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _button(
          background: AppColors.blue,
          foreground: AppColors.orange,
          fontSize: 28,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 11),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _button(
          background: AppColors.fieldSolid,
          foreground: AppColors.primary,
          fontSize: 13,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }
}