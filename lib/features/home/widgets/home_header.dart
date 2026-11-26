import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/press_icon_button.dart';
import '../../../core/widgets/profile_avatar.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final File? avatar;
  final VoidCallback onAvatarTap;
  final VoidCallback onNotificationsTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.avatar,
    required this.onAvatarTap,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onAvatarTap,
          child: ProfileAvatar(
            size: AppDimens.avatarRadius * 2,
            avatar: avatar,
            shadow: true,
            shadowFraction: AppDimens.homeShadowCircleFraction,
            imagePadding: AppDimens.avatarImagePaddingFraction,
          ),
        ),
        const SizedBox(width: AppDimens.homeHeaderGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.greeting,
                style: AppTextStyles.homeGreeting,
              ),
              Text(userName, style: AppTextStyles.homeUserName),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(10, 0),
          child: PressIconButton(
            asset: AppAssets.bell,
            pressedAsset: AppAssets.bellPressed,
            size: AppDimens.homeBellRadius * 2,
            toggle: true,
            onTap: onNotificationsTap,
          ),
        ),
      ],
    );
  }
}
