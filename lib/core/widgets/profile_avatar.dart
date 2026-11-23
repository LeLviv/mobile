
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.avatar,
    this.shadow = false,
    this.imagePadding = 0,
  });

  final double size;
  final File? avatar;
  final bool shadow;
  final double imagePadding;

  @override
  Widget build(BuildContext context) {
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
          if (avatar == null)
            SvgPicture.asset(
              AppAssets.avatar,
              width: size,
              height: size,
            )
          else
            Padding(
              padding: EdgeInsets.all(size * imagePadding),
              child: ClipOval(
                child: Image.file(
                  avatar!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                      AppAssets.avatar,
                      width: size,
                      height: size,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}