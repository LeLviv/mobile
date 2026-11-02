import 'package:flutter/material.dart';

class AppScale {
  AppScale(BuildContext context)
      : width = MediaQuery.sizeOf(context).width.clamp(320.0, 480.0),
        height = MediaQuery.sizeOf(context).height;

  final double width;
  final double height;

  double w(double factor) => width * factor;
  double font(double factor) => (width * factor).clamp(12.0, 40.0);
}