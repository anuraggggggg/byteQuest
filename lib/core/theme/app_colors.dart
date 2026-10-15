import 'package:flutter/material.dart';

/// App color palette for ByteQuest based on strict Design Tokens.
abstract class AppColors {
  /// Primary Background: Dark IDE canvas (#0D1117)
  static const Color background = Color(0xFF0D1117);

  /// Card / Container Surface (#161B26)
  static const Color surface = Color(0xFF161B26);

  /// Card / Container Border stroke (#2E384D)
  static const Color cardBorder = Color(0xFF2E384D);

  /// Primary Neon Glow: Electric Cyan (#00E5FF)
  static const Color primaryAccent = Color(0xFF00E5FF);

  /// Secondary Accent: Electric Royal Blue (#0075FF)
  static const Color secondaryAccent = Color(0xFF0075FF);

  /// Accent Gradient / Streak: Purple Neon (#9D4EDD)
  static const Color comboAccent = Color(0xFF9D4EDD);

  /// Correct Feedback: Neon Green (#00E676)
  static const Color successGreen = Color(0xFF00E676);

  /// Incorrect Feedback: Crimson Red (#FF3366)
  static const Color errorCrimson = Color(0xFFFF3366);

  /// Timer Warning / Sneaker Orange (#FF9100)
  static const Color warningOrange = Color(0xFFFF9100);

  /// Text Primary: Pure white (#FFFFFF)
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Text Secondary: Soft grayish cyan (#B0B9C6)
  static const Color textSecondary = Color(0xFFB0B9C6);

  // Helper UI tokens
  static const Color cardBorderActive = Color(0xFF00E5FF);
  static const Color panelNavy = Color(0xFF1E2235);
  static const Color codeBg = Color(0xFF0A0D14);
}
