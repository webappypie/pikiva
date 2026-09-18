import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

abstract final class AppRadii {
  static const double control = 16;
  static const double card = 24;
}

abstract final class AppColors {
  static const seed = Color(0xFF365C4B);
  static const lightSurface = Color(0xFFF8F9F5);
  static const darkSurface = Color(0xFF121613);
}

abstract final class AppElevation {
  static const double flat = 0;
  static const double raised = 1;
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 250);
  static const curve = Curves.easeInOutCubic;
}

abstract final class AppIconSize {
  static const double standard = 24;
  static const double hero = 48;
}

abstract final class AppLayout {
  static const double minimumTouchTarget = 48;
  static const double readingWidth = 560;
}

abstract final class AppTypography {
  // Platform fonts avoid runtime downloads and extra font binaries.
  static const heading = TextStyle(
    fontSize: 36,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
  );
  static const title = TextStyle(
    fontSize: 22,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(fontSize: 16, height: 1.5);
  static const caption = TextStyle(fontSize: 14, height: 1.5);
}
