import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/app_card.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: AppDimens.homeAlertCardAspect,
      child: AppCard(solid: true),
    );
  }
}