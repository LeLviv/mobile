import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/red_button.dart';

class WeatherCard extends StatelessWidget {
  final int temperature;
  final String title;
  final String advice;
  final VoidCallback onDetailsTap;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.title,
    required this.advice,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          width: AppDimens.weatherCardSize,
          height: AppDimens.weatherCardSize,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$temperature',
                  style: textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '°',
                  style: textTheme.headlineMedium
                      ?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimens.screenPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                advice,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: RedButton(
                  text: AppStrings.weatherDetails,
                  onPressed: onDetailsTap,
                  compact: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}