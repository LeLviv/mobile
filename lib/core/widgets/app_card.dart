import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';
import '../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;

  const AppCard({super.key, this.width, this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardFill,
        borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}