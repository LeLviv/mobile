import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.avatar,
    this.shadow = false,
  });

  final double size;
  final File? avatar;
  final bool shadow;

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
              width: size,
              height: size,
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
          ClipOval(
            child: avatar == null
                ? SvgPicture.asset(AppAssets.avatar, width: size, height: size)
                : Image.file(
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
        ],
      ),
    );
  }
}
