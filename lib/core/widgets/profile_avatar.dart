import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../profile/profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.size, this.shadow = false});

  final double size;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ProfileController.instance,
      builder: (context, _) {
        final image = ProfileController.instance.avatar;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (shadow)
                Container(
                  width: size * AppDimens.homeShadowCircleFraction,
                  height: size * AppDimens.homeShadowCircleFraction,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.homeShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              if (image == null)
                SvgPicture.asset(AppAssets.avatar, width: size, height: size)
              else
                ClipOval(
                  child: Image.file(
                    image,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
