import 'package:flutter/material.dart';
import '../../core/profile/profile_controller.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'data/weather_repository.dart';
import 'data/weather_texts.dart';
import 'models/weather_info.dart';
import 'widgets/alert_card.dart';
import 'widgets/home_header.dart';
import 'widgets/weather_card.dart';
import '../../core/constants/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _userName = "Прізвище Ім'я";

  final WeatherRepository _weatherRepository = WeatherRepository();
  late Future<WeatherInfo> _weather;

  @override
  void initState() {
    super.initState();
    _weather = _weatherRepository.fetchCurrent();
  }

  void _reloadWeather() {
    setState(() => _weather = _weatherRepository.fetchCurrent());
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

        if (snapshot.hasError) {
          debugPrint('Weather error: ${snapshot.error}');
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
                : const CircularProgressIndicator(
              color: AppColors.homePrimary,
            ),
          ),
        );
      },
    );
  }

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
            ListenableBuilder(
              listenable: ProfileController.instance,
              builder: (context, _) {
                final name = ProfileController.instance.name;

                return HomeHeader(
                  userName: name.isEmpty ? _userName : name,
                  onNotificationsTap: () {},
                  onAvatarTap: () =>
                      Navigator.pushNamed(context, AppRoutes.usersettings),
                );
              },
            ),
            const SizedBox(height: AppDimens.homeHeaderToAlertGap),
            const AlertCard(),
            const SizedBox(height: AppDimens.homeAlertToWeatherGap),
            _buildWeather(),
            const SizedBox(height: AppDimens.homeWeatherToOutagesGap),
            const AppCard(solid: true, height: AppDimens.homeOutagesCardHeight),
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
              child: InkWell(customBorder: const CircleBorder(), onTap: () {}),
            ),
          ),
        ),
      ],
    );
  }
}
