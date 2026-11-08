import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCard(
          solid: true,
          width: AppDimens.homeWeatherCardSize,
          height: AppDimens.homeWeatherCardSize,
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(
                        AppDimens.homeTemperatureOffsetX,
                        AppDimens.homeTemperatureOffsetY,
                      ),
                      child: Text('$temperature', style: AppTextStyles.homeTemperature),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimens.homeDegreeTop,
                        left: AppDimens.homeDegreeLeft,
                      ),
                      child: Text('°', style: AppTextStyles.homeDegree),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                left: 12,
                child: Image.asset(
                  AppAssets.sun,
                  width: AppDimens.homeSunSize,
                  height: AppDimens.homeSunSize,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.homeWeatherTextGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scaleX: 0.9,
                scaleY: 0.8,
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.homeWeatherTitle),
              ),
              const SizedBox(height: 2),
              Text(advice, style: AppTextStyles.homeWeatherAdvice),
              const SizedBox(height: 1),
              Align(
                alignment: Alignment.centerRight,
                child: _DetailsButton(onPressed: onDetailsTap),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsButton extends StatefulWidget {
  final VoidCallback onPressed;

  final bool toggle;

  const _DetailsButton({required this.onPressed, this.toggle = true});

  @override
  State<_DetailsButton> createState() => _DetailsButtonState();
}

class _DetailsButtonState extends State<_DetailsButton> {
  bool _pressed = false;
  bool _active = false;

  void _setPressed(bool value) {
    if (widget.toggle) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _handleTap() {
    if (widget.toggle) setState(() => _active = !_active);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.toggle ? _active : _pressed;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: AppDimens.buttonHeightCompact,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: highlighted
              ? AppColors.homeBackground
              : AppColors.homePrimary,
          borderRadius:
          BorderRadius.circular(AppDimens.homeDetailsButtonRadius),
          border: Border.all(
            color: AppColors.homePrimary,
            width: AppDimens.homeDetailsBorderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.homeShadow,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            AppStrings.weatherDetails,
            style: AppTextStyles.homeButton.copyWith(
              color: highlighted
                  ? AppColors.homePrimary
                  : AppColors.homeOnPrimary,
            ),
          ),
        ),
      ),
    );
  }
}