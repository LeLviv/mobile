import 'package:flutter/material.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/red_button.dart';
import 'widgets/alert_card.dart';
import 'widgets/app_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/power_outages_card.dart';
import 'widgets/weather_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 2;

  final String _userName = "Прізвище Ім'я";
  final bool _alertActive = false;
  final int _temperature = 18;
  final String _weatherTitle = 'СОНЯЧНО';
  final String _weatherAdvice =
      'одягайтеся легко, чудовий час для прогулянки з колясками';
  final List<PowerOutage> _outages = const [
    PowerOutage(time: '14:00 – 18:00', group: 'Група 1.1'),
    PowerOutage(time: '20:00 – 23:00', group: 'Група 1.2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.screenPadding,
                AppDimens.screenPadding,
                AppDimens.screenPadding,
                AppDimens.listBottomPadding,
              ),
              children: [
                HomeHeader(
                  userName: _userName,
                  onNotificationsTap: () {
                  },
                ),
                const SizedBox(height: AppDimens.sectionGap),
                AlertCard(isActive: _alertActive),
                const SizedBox(height: AppDimens.smallGap),
                RedButton(
                  text: AppStrings.alertMapButton,
                  onPressed: () {
                  },
                ),
                const SizedBox(height: AppDimens.sectionGap),
                WeatherCard(
                  temperature: _temperature,
                  title: _weatherTitle,
                  advice: _weatherAdvice,
                  onDetailsTap: () {
                  },
                ),
                const SizedBox(height: AppDimens.sectionGap),
                PowerOutagesCard(outages: _outages),
              ],
            ),
            Positioned(
              right: AppDimens.screenPadding + 4,
              bottom: AppDimens.fabBottom,
              child: FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () {
                },
                child: const Icon(Icons.add, color: AppColors.onPrimary),
              ),
            ),
            Positioned(
              left: AppDimens.navMargin,
              right: AppDimens.navMargin,
              bottom: AppDimens.navMargin,
              child: AppBottomNav(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}