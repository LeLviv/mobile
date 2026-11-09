import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: AppTextStyles.homeUserName));
  }
}