import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF7F402F);
  static const Color primaryLight = Color(0xFFA65D48);
  static const Color primaryDark = Color(0xFF5C2E21);

  static const Color buttonBackground = primary;
  static const Color buttonDisabled = Color(0xFFB8A99A);

  static const Color textOnPrimary = Color(0xFFF3E3CA);
  static const Color textOnPrimaryLight = Color(0xFFFFF5E8);

  static const Color secondary = Color(0xFFB89A7A);
  static const Color secondaryLight = Color(0xFFD4BCA3);
  static const Color secondaryDark = Color(0xFF8B6F55);

  static const Color background = Color(0xFFFAF3EA);
  static const Color surface = Color(0xFFFFF5E8);
  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF3E2C23);
  static const Color textSecondary = Color(0xFF6B5A4E);
  static const Color textHint = Color(0xFF9B8B80);

  static const Color success = Color(0xFF5D8B6B);
  static const Color error = Color(0xFFB85C5C);
  static const Color warning = Color(0xFFE6B87A);
  static const Color info = Color(0xFF6B8B9B);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF5E8), Color(0xFFFAF3EA)],
  );

  static const Color shadow = Color(0x1A3E2C23);
  static const Color overlay = Color(0x803E2C23);

  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentCream = Color(0xFFFFF0DB);
  static const Color accentWarm = Color(0xFFE6D5B8);

  static const Color starActive = Color(0xFFD4AF37);
  static const Color starInactive = Color(0xFFE6D5B8);
}
