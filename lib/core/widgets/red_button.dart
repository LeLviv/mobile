import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';
import '../theme/app_colors.dart';

class RedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool compact;

  const RedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? null : double.infinity,
      height:
      compact ? AppDimens.buttonHeightCompact : AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: compact ? const EdgeInsets.symmetric(horizontal: 24) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}