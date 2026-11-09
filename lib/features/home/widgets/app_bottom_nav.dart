import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class _NavItem {
  final String asset;
  final String label;
  const _NavItem(this.asset, this.label);
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
    _NavItem(AppAssets.navTransport, AppStrings.navTransport),
    _NavItem(AppAssets.navNews, AppStrings.navNews),
    _NavItem(AppAssets.navHome, AppStrings.navHome),
    _NavItem(AppAssets.navEvents, AppStrings.navEvents),
    _NavItem(AppAssets.navForms, AppStrings.navForms),
  ];

  @override
  Widget build(BuildContext context) {
    final count = _items.length;
    final alignX = -1 + 2 * currentIndex / (count - 1);

    return Container(
      height: AppDimens.navHeight,
      decoration: BoxDecoration(
        color: AppColors.homePrimary,
        borderRadius: BorderRadius.circular(AppDimens.navRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.homeShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.homeNavInnerPadding,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedAlign(
              alignment: Alignment(alignX, 0),
              duration: const Duration(
                milliseconds: AppDimens.homeNavAnimationMs,
              ),
              curve: Curves.easeOutCubic,
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -AppDimens.homeNavActiveLift),
                    child: Container(
                      width: AppDimens.homeNavActiveSize,
                      height: AppDimens.homeNavActiveSize,
                      decoration: const BoxDecoration(
                        color: AppColors.homeOnPrimary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.homeNavCircleShadow,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: List.generate(count, (i) {
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: Center(
                      child: _NavItemView(
                        item: _items[i],
                        active: i == currentIndex,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemView extends StatelessWidget {
  final _NavItem item;
  final bool active;

  const _NavItemView({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: active ? 1 : 0),
      duration: const Duration(milliseconds: AppDimens.homeNavAnimationMs),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        final color =
        Color.lerp(AppColors.homeBodyText, AppColors.homePrimary, t)!;

        return Transform.translate(
          offset: Offset(0, -AppDimens.homeNavActiveLift * t),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                item.asset,
                width: AppDimens.homeNavIconSize,
                height: AppDimens.homeNavIconSize,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: AppTextStyles.homeNavLabel.copyWith(color: color),
              ),
            ],
          ),
        );
      },
    );
  }
}