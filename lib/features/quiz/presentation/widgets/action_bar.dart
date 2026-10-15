import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ActionBar extends StatelessWidget {
  final bool isEnabled;
  final bool isLastQuestion;
  final VoidCallback onPressed;

  const ActionBar({
    super.key,
    required this.isEnabled,
    required this.isLastQuestion,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.8),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled
                  ? (isLastQuestion
                      ? AppColors.comboAccent
                      : AppColors.primaryAccent)
                  : AppColors.panelNavy,
              foregroundColor: isEnabled ? AppColors.background : AppColors.textSecondary,
              disabledBackgroundColor: AppColors.panelNavy.withValues(alpha: 0.5),
              disabledForegroundColor: AppColors.textSecondary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: isEnabled ? 8 : 0,
              shadowColor: isLastQuestion
                  ? AppColors.comboAccent.withValues(alpha: 0.5)
                  : AppColors.primaryAccent.withValues(alpha: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastQuestion ? 'Complete Quest 🎉' : 'Next Challenge',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isEnabled
                        ? (isLastQuestion
                            ? AppColors.textPrimary
                            : AppColors.background)
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isLastQuestion
                      ? Icons.emoji_events_rounded
                      : Icons.arrow_forward_rounded,
                  size: 20,
                  color: isEnabled
                      ? (isLastQuestion
                          ? AppColors.textPrimary
                          : AppColors.background)
                      : AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
