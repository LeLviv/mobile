import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/profile/profile_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'data/weather_repository.dart';
import 'data/weather_texts.dart';
import 'models/weather_info.dart';
import 'widgets/alert_section.dart';
import 'widgets/home_header.dart';
import 'widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const String _userName = "Прізвище Ім'я";
  static const Duration _refreshInterval = Duration(minutes: 10);

  final WeatherRepository _weatherRepository = WeatherRepository();
  late Future<WeatherInfo> _weather;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _weather = _weatherRepository.fetchCurrent();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    _weatherRepository.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _reloadWeather();
        _startTimer();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopTimer();
    }
  }

  void _startTimer() {
    _timer ??= Timer.periodic(_refreshInterval, (_) => _reloadWeather());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _reloadWeather() {
    if (!mounted) return;
    setState(() => _weather = _weatherRepository.fetchCurrent());
  }

  Future<void> _onRefresh() async {
    final future = _weatherRepository.fetchCurrent();
    setState(() => _weather = future);
    try {
      await future;
    } catch (_) {}
  }

  Widget _buildWeather() {
    return FutureBuilder<WeatherInfo>(
      future: _weather,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return WeatherCard(
            temperature: weather.roundedTemperature,
            title: weather.condition.title,
            advice: WeatherTexts.advice(weather),
            onDetailsTap: () {},
          );
        }

        return SizedBox(
          height: AppDimens.homeWeatherCardSize,
          child: Center(
            child: snapshot.hasError
                ? GestureDetector(
                    onTap: _reloadWeather,
                    child: const Text(
                      AppStrings.weatherLoadError,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.homeWeatherAdvice,
                    ),
                  )
                : const CircularProgressIndicator(color: AppColors.homePrimary),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.homePrimary,
          onRefresh: _onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppDimens.homeScreenPadding,
              AppDimens.homeScreenPadding,
              AppDimens.homeScreenPadding,
              AppDimens.homeListBottomPadding,
            ),
            children: [
              ListenableBuilder(
                listenable: ProfileController.instance,
                builder: (context, _) {
                  final name = ProfileController.instance.name;
                  final avatar = ProfileController.instance.avatar;

                  return HomeHeader(
                    userName: name.isEmpty ? _userName : name,
                    avatar: avatar,
                    onNotificationsTap: () {},
                    onAvatarTap: () =>
                        Navigator.pushNamed(context, AppRoutes.usersettings),
                  );
                },
              ),
              const SizedBox(height: AppDimens.homeHeaderToAlertGap),
              const AlertSection(),
              const SizedBox(height: AppDimens.homeAlertToWeatherGap),
              _buildWeather(),
              const SizedBox(height: AppDimens.homeWeatherToOutagesGap),
              const AppCard(
                solid: true,
                height: AppDimens.homeOutagesCardHeight,
              ),
            ],
          ),
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
              child: InkWell(customBorder: const CircleBorder(), onTap: () {}),
            ),
          ),
        ),
      ],
    );
  }
}
