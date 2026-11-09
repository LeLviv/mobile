import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/widgets/placeholder_page.dart';
import 'home_page.dart';
import 'widgets/app_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 2;

  static const List<Widget> _pages = [
    PlaceholderPage(title: AppStrings.navTransport),
    PlaceholderPage(title: AppStrings.navNews),
    HomePage(),
    PlaceholderPage(title: AppStrings.navEvents),
    PlaceholderPage(title: AppStrings.navForms),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(index: _navIndex, children: _pages),
            Positioned(
              left: AppDimens.navMargin,
              right: AppDimens.navMargin,
              bottom: AppDimens.navMargin,
              child: AppBottomNav(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}