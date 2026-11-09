import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/widgets/app_card.dart';
import 'widgets/alert_card.dart';
import 'widgets/home_header.dart';
import 'widgets/weather_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _userName = "Прізвище Ім'я";
  static const int _temperature = 18;
  static const String _weatherTitle = 'СОНЯЧНО';
  static const String _weatherAdvice =
      'одягайтеся легко, чудовий час для пальта та шпацеру з коліжанками';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.homeScreenPadding,
            AppDimens.homeScreenPadding,
            AppDimens.homeScreenPadding,
            AppDimens.homeListBottomPadding,
          ),
          children: [
            HomeHeader(
              userName: _userName,
              onNotificationsTap: () {},
              onAvatarTap: () {},
            ),
            const SizedBox(height: AppDimens.homeHeaderToAlertGap),
            const AlertCard(),
            const SizedBox(height: AppDimens.homeAlertToWeatherGap),
            WeatherCard(
              temperature: _temperature,
              title: _weatherTitle,
              advice: _weatherAdvice,
              onDetailsTap: () {},
            ),
            const SizedBox(height: AppDimens.homeWeatherToOutagesGap),
            const AppCard(
              solid: true,
              height: AppDimens.homeOutagesCardHeight,
            ),
          ],
        ),
        Positioned(
          right: AppDimens.homeFabRight,
          bottom: AppDimens.navHeight + AppDimens.navMargin + AppDimens.spaceM,
          child: Container(
            width: AppDimens.homeFabSize,
            height: AppDimens.homeFabSize,
            decoration: const BoxDecoration(
              color: AppColors.homePrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.homeShadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}