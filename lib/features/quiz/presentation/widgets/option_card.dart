import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OptionCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  String get optionLetter => String.fromCharCode(65 + index); // A, B, C, D

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.cardBorder;
    Color bgColor = AppColors.surface;
    Color letterBg = AppColors.panelNavy;
    Color letterColor = AppColors.primaryAccent;
    IconData? trailingIcon;
    Color iconColor = Colors.transparent;

    if (isAnswered) {
      if (isCorrect) {
        borderColor = AppColors.successGreen;
        bgColor = AppColors.successGreen.withValues(alpha: 0.12);
        letterBg = AppColors.successGreen;
        letterColor = AppColors.background;
        trailingIcon = Icons.check_circle_rounded;
        iconColor = AppColors.successGreen;
      } else if (isSelected) {
        borderColor = AppColors.errorCrimson;
        bgColor = AppColors.errorCrimson.withValues(alpha: 0.12);
        letterBg = AppColors.errorCrimson;
        letterColor = AppColors.textPrimary;
        trailingIcon = Icons.cancel_rounded;
        iconColor = AppColors.errorCrimson;
      }
    } else if (isSelected) {
      borderColor = AppColors.primaryAccent;
      bgColor = AppColors.primaryAccent.withValues(alpha: 0.1);
      letterBg = AppColors.primaryAccent;
      letterColor = AppColors.background;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primaryAccent.withValues(alpha: 0.2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && isCorrect) ? 2.0 : 1.2,
              ),
              boxShadow: isSelected || (isAnswered && isCorrect)
                  ? [
                      BoxShadow(
                        color: borderColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Option Letter Badge (A, B, C, D)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: letterBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    optionLetter,
                    style: TextStyle(
                      color: letterColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Option Code Text
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),

                // Trailing Feedback Icon
                if (trailingIcon != null)
                  Icon(
                    trailingIcon,
                    color: iconColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
