import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _font = 'Neucha';
  static const homeGreeting = TextStyle(
    fontSize: 14,
    height: 1.1,
    color: AppColors.homePrimary,
  );

  static const homeUserName = TextStyle(
    fontSize: 20,
    height: 1.1,
    color: AppColors.homePrimary,
  );

  static const homeTemperature = TextStyle(
    fontSize: 96,
    height: 1,
    color: AppColors.homePrimary,
    shadows: [
      Shadow(color: AppColors.homePrimary, offset: Offset(0.1, 0)),
      Shadow(color: AppColors.homePrimary, offset: Offset(-0.1, 0)),
      Shadow(color: AppColors.homePrimary, offset: Offset(0, 0.1)),
      Shadow(color: AppColors.homePrimary, offset: Offset(0, -0.1)),
    ],
  );

  static const homeDegree = TextStyle(
    fontSize: 50,
    height: 1,
    color: AppColors.homePrimary,
    shadows: [
      Shadow(color: AppColors.homePrimary, offset: Offset(0.6, 0)),
      Shadow(color: AppColors.homePrimary, offset: Offset(-0.6, 0)),
    ],
  );

  static const homeWeatherTitle = TextStyle(
    fontSize: 34,
    height: 1.1,
    color: AppColors.homePrimary,
    shadows: [
      Shadow(color: AppColors.homePrimary, offset: Offset(0.2, 0)),
      Shadow(color: AppColors.homePrimary, offset: Offset(-0.2, 0)),
    ],
  );

  static const homeWeatherAdvice = TextStyle(
    fontSize: 17,
    height: 1.1,
    color: AppColors.homeBodyText,
  );

  static const homeButton = TextStyle(
    fontSize: 15,
    color: AppColors.homeOnPrimary,
  );

  static const homeNavLabel = TextStyle(
    fontFamily: _font,
    fontSize: 10,
  );
}