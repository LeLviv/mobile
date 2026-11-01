import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';

class PowerOutage {
  final String time;
  final String group;

  const PowerOutage({required this.time, required this.group});
}

class PowerOutagesCard extends StatelessWidget {
  final List<PowerOutage> outages;

  const PowerOutagesCard({super.key, required this.outages});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  AppStrings.outagesTitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.smallGap),
            if (outages.isEmpty)
              Text(
                AppStrings.outagesEmpty,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.primary),
              )
            else
              ...outages.map(
                    (o) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(o.time,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: AppColors.primary)),
                      Text(o.group,
                          style: textTheme.bodyMedium
                              ?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}