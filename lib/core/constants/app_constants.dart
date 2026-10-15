/// Global application constants for ByteQuest.
class AppConstants {
  AppConstants._();

  static const String appName = 'ByteQuest';
  static const String appVersion = '1.0.0+1';
  static const String appTagline = 'Code, Quiz & Level Up';

  // Animation & Delay Durations
  static const Duration splashDuration = Duration(milliseconds: 2400);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 350);
  static const Duration companionReactionDuration = Duration(milliseconds: 1500);

  // Asset Paths
  static const String logoAsset = 'assets/app_logo.png';
  static const String splashBgAsset = 'assets/images/splash_bg.jpg';
  static const String codieFolder = 'assets/images/codie/';

  // Score & Rewards
  static const int pointsPerCorrectAnswer = 100;
  static const int streakBonusMultiplier = 20;
}
