import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationsTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const CircleAvatar(
          radius: AppDimens.avatarRadius,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: AppColors.onPrimary),
        ),
        const SizedBox(width: AppDimens.smallGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.greeting,
                style: textTheme.bodySmall?.copyWith(color: AppColors.primary),
              ),
              Text(
                userName,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: AppDimens.avatarRadius,
          backgroundColor: AppColors.primary,
          child: IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.onPrimary),
            onPressed: onNotificationsTap,
          ),
        ),
      ],
    );
  }
}