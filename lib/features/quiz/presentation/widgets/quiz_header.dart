import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuizHeader extends StatelessWidget {
  final int streak;
  final int score;
  final int secondsRemaining;
  final int totalTime;

  const QuizHeader({
    super.key,
    required this.streak,
    required this.score,
    required this.secondsRemaining,
    this.totalTime = 15,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (secondsRemaining / totalTime).clamp(0.0, 1.0);
    final timerColor = secondsRemaining <= 5
        ? AppColors.warningOrange
        : (streak >= 3 ? AppColors.comboAccent : AppColors.primaryAccent);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: streak >= 3
              ? AppColors.comboAccent.withValues(alpha: 0.6)
              : AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (streak >= 3 ? AppColors.comboAccent : AppColors.primaryAccent)
                .withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Streak Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.panelNavy,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: streak >= 3
                        ? AppColors.comboAccent
                        : AppColors.warningOrange.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '🔥',
                      style: TextStyle(fontSize: streak >= 3 ? 18 : 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$streak Streak',
                      style: TextStyle(
                        color: streak >= 3
                            ? AppColors.comboAccent
                            : AppColors.warningOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Timer Indicator
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: timerColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${secondsRemaining}s',
                    style: TextStyle(
                      color: timerColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),

              // Score Counter
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.panelNavy,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryAccent.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.primaryAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$score XP',
                      style: const TextStyle(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Timer Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.panelNavy,
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            ),
          ),
        ],
      ),
    );
  }
}
