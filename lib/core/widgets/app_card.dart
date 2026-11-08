import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class AppCard extends StatelessWidget {
  final double? width;
  final double? height;
  final bool solid;
  final Widget? child;

  const AppCard({
    super.key,
    this.width,
    this.height,
    this.solid = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: solid ? AppColors.homeCard : AppColors.cardFill,
        borderRadius: BorderRadius.circular(
          solid ? AppDimens.homeCardRadius : AppDimens.cardRadius,
        ),
        border: solid ? null : Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}