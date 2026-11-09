import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/app_card.dart';

class PowerOutagesCard extends StatelessWidget {
  const PowerOutagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: AppDimens.homeOutagesCardAspect,
      child: AppCard(solid: true),
    );
  }
}