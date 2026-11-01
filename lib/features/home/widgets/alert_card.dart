import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';

class AlertCard extends StatelessWidget {
  final bool isActive;

  const AlertCard({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: AppDimens.alertCardHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.warning_amber_rounded : Icons.shield_outlined,
              size: 40,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              isActive ? AppStrings.alertActive : AppStrings.alertNone,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}