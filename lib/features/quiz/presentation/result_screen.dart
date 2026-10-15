import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../mascot/presentation/byte_mascot.dart';
import '../data/mock_questions.dart';
import 'stage_select_screen.dart';

class ResultScreen extends StatelessWidget {
  final String playerName;
  final QuizStage stage;
  final int finalScore;
  final int maxStreak;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.playerName,
    required this.stage,
    required this.finalScore,
    required this.maxStreak,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ByteMascot in Correct / Victory state
                ByteMascot(
                  state: ByteState.correct,
                  speechText: maxStreak >= 3
                      ? 'UNSTOPPABLE CODE MASTER $playerName! ⚡'
                      : 'Great work $playerName! ${stage.title} Cleared! 🎉',
                  size: 140,
                ),
                const SizedBox(height: 28),

                // Victory Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primaryAccent, AppColors.comboAccent],
                  ).createShader(bounds),
                  child: const Text(
                    'STAGE CLEARED',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${stage.iconEmoji} ${stage.title}',
                  style: TextStyle(
                    color: stage.accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Container Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cardBorder,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('CODER', playerName, Icons.person_rounded, AppColors.secondaryAccent),
                      Container(width: 1, height: 40, color: AppColors.cardBorder),
                      _buildStatColumn('TOTAL XP', '$finalScore', Icons.star_rounded, AppColors.primaryAccent),
                      Container(width: 1, height: 40, color: AppColors.cardBorder),
                      _buildStatColumn('MAX STREAK', '$maxStreak 🔥', Icons.local_fire_department_rounded, AppColors.warningOrange),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Replay & Change Stage Buttons
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onRestart,
                    icon: const Icon(Icons.replay_rounded, size: 22),
                    label: const Text(
                      'Replay Stage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => StageSelectScreen(
                            initialPlayerName: playerName,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.apps_rounded, color: AppColors.primaryAccent),
                    label: const Text(
                      'Select Another Stage',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: AppColors.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
