import 'package:flutter/material.dart';

import '../profile/profile_controller.dart';
import '../theme/app_colors.dart';

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
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.loginAccent,
            boxShadow: shadow
                ? const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ]
                : null,
            image: image == null
                ? null
                : DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
          child: image == null
              ? Icon(Icons.person, size: size * 0.7, color: Colors.white)
              : null,
        );
      },
    );
  }
}