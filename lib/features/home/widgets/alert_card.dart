import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_scale.dart';
import '../../../core/theme/app_text_styles.dart';

class AlertCard extends StatelessWidget {
  final bool isActive;

  const AlertCard({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final s = AppScale(context);

    final background = isActive
        ? AppColors.homeAlertActiveBackground
        : AppColors.homeAlertCalmBackground;
    final titleColor = isActive
        ? AppColors.homeAlertActiveTitle
        : AppColors.homeAlertCalmTitle;

    final titleStyle = AppTextStyles.homeAlertTitle.copyWith(
      color: titleColor,
      fontSize: s.font(AppDimens.homeAlertTitleFactor),
    );
    final bodyStyle = AppTextStyles.homeAlertBody.copyWith(
      color: AppColors.homeBodyText,
      fontSize: s.font(AppDimens.homeAlertBodyFactor),
    );

    const gap = SizedBox(height: AppDimens.homeAlertGap);

    return AspectRatio(
      aspectRatio: AppDimens.homeAlertCardAspect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(AppDimens.homeAlertPadding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppDimens.homeCardRadius),
        ),
        child: Row(
          children: [
            Expanded(
              flex: AppDimens.homeAlertImageFlex,
              child: SvgPicture.asset(
                isActive ? AppAssets.alertActive : AppAssets.alertCalm,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: AppDimens.homeAlertTextFlex,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isActive
                        ? AppStrings.alertActiveTitle
                        : AppStrings.alertCalmTitle,
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  gap,
                  Text(
                    isActive
                        ? AppStrings.alertActiveLine1
                        : AppStrings.alertCalmLine1,
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  gap,
                  Container(
                    width: AppDimens.homeAlertDividerWidth,
                    height: AppDimens.homeAlertDividerHeight,
                    color: AppColors.homeBodyText,
                  ),
                  gap,
                  Text(
                    isActive
                        ? AppStrings.alertActiveLine2
                        : AppStrings.alertCalmLine2,
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}