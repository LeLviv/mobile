import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(Icons.location_on_outlined, AppStrings.navTransport),
    _NavItem(Icons.campaign_outlined, AppStrings.navNews),
    _NavItem(Icons.home_outlined, AppStrings.navHome),
    _NavItem(Icons.star_border, AppStrings.navEvents),
    _NavItem(Icons.edit_outlined, AppStrings.navForms),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.navHeight,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimens.navRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final color = i == currentIndex
              ? AppColors.onPrimary
              : AppColors.onPrimaryMuted;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_items[i].icon, color: color),
                const SizedBox(height: 2),
                Text(
                  _items[i].label,
                  style: TextStyle(fontSize: 10, color: color),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}