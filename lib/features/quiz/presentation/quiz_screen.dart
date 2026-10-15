import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../mascot/presentation/byte_mascot.dart';
import '../data/mock_questions.dart';
import 'quiz_controller.dart';
import 'result_screen.dart';
import 'widgets/action_bar.dart';
import 'widgets/code_snippet_card.dart';
import 'widgets/option_card.dart';
import 'widgets/quiz_header.dart';

class QuizScreen extends StatefulWidget {
  final String playerName;
  final QuizStage? stage;

  const QuizScreen({
    super.key,
    this.playerName = 'Coder',
    this.stage,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuizController(
      playerName: widget.playerName,
      stage: widget.stage,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QuizState>(
      valueListenable: _controller,
      builder: (context, state, child) {
        final currentQuestion = state.currentQuestion;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Stack(
              children: [
                // 1. MAIN QUEST UI (Header, Question, Options, Action Bar)
                Column(
                  children: [
                    // Player & Stage Indicator Header Pill
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Player Name Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_rounded,
                                  size: 16,
                                  color: AppColors.primaryAccent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.playerName,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Stage Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: state.stage.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: state.stage.accentColor),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  state.stage.iconEmoji,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.stage.title,
                                  style: TextStyle(
                                    color: state.stage.accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Top Header Progress & Score Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: QuizHeader(
                        streak: state.streak,
                        score: state.score,
                        secondsRemaining: state.secondsRemaining,
                      ),
                    ),

                    // Scrollable Quest Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // Code Snippet Box
                            CodeSnippetCard(
                              language: currentQuestion.language,
                              title: currentQuestion.title,
                              codeSnippet: currentQuestion.codeSnippet,
                            ),
                            const SizedBox(height: 12),

                            // 4 Multiple Choice Option Cards
                            ...List.generate(
                              currentQuestion.options.length,
                              (index) => OptionCard(
                                index: index,
                                text: currentQuestion.options[index],
                                isSelected: state.selectedOptionIndex == index,
                                isAnswered: state.isAnswered,
                                isCorrect: currentQuestion.correctOptionIndex == index,
                                onTap: () => _controller.selectOption(index),
                              ),
                            ),

                            // Extra bottom padding so scrollable content is clear of bottom corner mascot & action bar
                            const SizedBox(height: 130),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action Bar
                    ActionBar(
                      isEnabled: state.isAnswered,
                      isLastQuestion: state.isLastQuestion,
                      onPressed: () {
                        if (state.isLastQuestion) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                playerName: state.playerName,
                                stage: state.stage,
                                finalScore: state.score,
                                maxStreak: state.streak,
                                onRestart: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                        playerName: state.playerName,
                                        stage: state.stage,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          _controller.nextQuestion();
                        }
                      },
                    ),
                  ],
                ),

                // 2. CORNER MASCOT COMPANION OVERLAY
                // Pinned in the bottom-right corner ALL THE TIME while quest is running!
                // Dynamic Happy, Sad, Thinking, & Idle reactions!
                Positioned(
                  bottom: 74,
                  right: 12,
                  child: _CornerMascotCompanion(
                    state: state.byteState,
                    speechText: state.speechText,
                    onTap: _controller.toggleHint,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Floating Corner Companion Mascot Widget
/// Pinned in the corner throughout the quest with real-time mood indicators
class _CornerMascotCompanion extends StatelessWidget {
  final ByteState state;
  final String speechText;
  final VoidCallback onTap;

  const _CornerMascotCompanion({
    required this.state,
    required this.speechText,
    required this.onTap,
  });

  String get _moodBadgeText {
    switch (state) {
      case ByteState.correct:
        return 'HAPPY 🎉';
      case ByteState.wrong:
        return 'SAD 🐛';
      case ByteState.thinking:
        return 'THINKING 🧠';
      case ByteState.pointing:
        return 'GUIDING 👉';
      case ByteState.idle:
        return 'READY 🚀';
    }
  }

  Color get _moodBadgeColor {
    switch (state) {
      case ByteState.correct:
        return AppColors.successGreen;
      case ByteState.wrong:
        return AppColors.errorCrimson;
      case ByteState.thinking:
        return AppColors.secondaryAccent;
      case ByteState.pointing:
        return AppColors.comboAccent;
      case ByteState.idle:
        return AppColors.primaryAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Corner Mood Status Pill & Speech Bubble
        Container(
          constraints: const BoxConstraints(maxWidth: 220),
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _moodBadgeColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _moodBadgeColor.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Live Mood Badge Header
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _moodBadgeColor,
                      boxShadow: [
                        BoxShadow(
                          color: _moodBadgeColor,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _moodBadgeText,
                    style: TextStyle(
                      color: _moodBadgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Speech / Hint Text
              Text(
                speechText,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // ByteMascot Character Icon in the corner
        ByteMascot(
          state: state,
          speechText: null, // Speech rendered in the custom corner container above
          onTap: onTap,
          size: 90,
        ),
      ],
    );
  }
}
