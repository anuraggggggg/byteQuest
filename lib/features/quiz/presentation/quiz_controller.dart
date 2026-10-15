import 'dart:async';
import 'package:flutter/material.dart';
import '../../mascot/presentation/byte_mascot.dart';
import '../domain/models/question_model.dart';
import '../data/mock_questions.dart';

class QuizState {
  final String playerName;
  final QuizStage stage;
  final int currentQuestionIndex;
  final int selectedOptionIndex;
  final bool isAnswered;
  final int score;
  final int streak;
  final int secondsRemaining;
  final ByteState byteState;
  final String speechText;

  QuizState({
    required this.playerName,
    required this.stage,
    required this.currentQuestionIndex,
    this.selectedOptionIndex = -1,
    this.isAnswered = false,
    required this.score,
    required this.streak,
    required this.secondsRemaining,
    required this.byteState,
    required this.speechText,
  });

  Question get currentQuestion => stage.questions[currentQuestionIndex];
  bool get isLastQuestion => currentQuestionIndex >= stage.questions.length - 1;

  QuizState copyWith({
    String? playerName,
    QuizStage? stage,
    int? currentQuestionIndex,
    int? selectedOptionIndex,
    bool? isAnswered,
    int? score,
    int? streak,
    int? secondsRemaining,
    ByteState? byteState,
    String? speechText,
  }) {
    return QuizState(
      playerName: playerName ?? this.playerName,
      stage: stage ?? this.stage,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      isAnswered: isAnswered ?? this.isAnswered,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      byteState: byteState ?? this.byteState,
      speechText: speechText ?? this.speechText,
    );
  }
}

class QuizController extends ValueNotifier<QuizState> {
  Timer? _timer;
  static const int totalTimePerQuestion = 15;

  QuizController({
    String playerName = 'Coder',
    QuizStage? stage,
  }) : super(
          QuizState(
            playerName: playerName,
            stage: stage ?? quizStages[0],
            currentQuestionIndex: 0,
            score: 0,
            streak: 0,
            secondsRemaining: totalTimePerQuestion,
            byteState: ByteState.idle,
            speechText: 'Welcome $playerName! Tap me for a hint! 💡',
          ),
        ) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value.isAnswered) {
        timer.cancel();
        return;
      }

      if (value.secondsRemaining > 1) {
        final newTime = value.secondsRemaining - 1;
        final mascotState = (newTime <= 5 && value.streak < 3)
            ? ByteState.thinking
            : ByteState.idle;

        final speech = (newTime <= 5 && value.streak < 3)
            ? 'Tick-tock ${value.playerName}! Pick an answer! ⏳'
            : value.speechText;

        value = value.copyWith(
          secondsRemaining: newTime,
          byteState: mascotState,
          speechText: speech,
        );
      } else {
        timer.cancel();
        handleTimeOut();
      }
    });
  }

  void handleTimeOut() {
    if (value.isAnswered) return;

    value = value.copyWith(
      isAnswered: true,
      secondsRemaining: 0,
      streak: 0,
      byteState: ByteState.wrong,
      speechText: "Time's up! Bug caught! Let's debug.",
    );
  }

  void selectOption(int index) {
    if (value.isAnswered) return;

    _timer?.cancel();
    final question = value.currentQuestion;
    final isCorrect = (index == question.correctOptionIndex);

    final newStreak = isCorrect ? value.streak + 1 : 0;
    final scoreBonus = isCorrect ? (100 + (newStreak * 20)) : 0;
    final newScore = value.score + scoreBonus;

    ByteState mascotState;
    String speech;

    if (isCorrect) {
      mascotState = ByteState.correct;
      speech = newStreak >= 3
          ? '🔥 OVERPOWERED STREAK x$newStreak! Great code ${value.playerName}! +$scoreBonus XP'
          : 'Clean code ${value.playerName}! +$scoreBonus XP';
    } else {
      mascotState = ByteState.wrong;
      speech = "Bug caught! Let's debug.";
    }

    value = value.copyWith(
      selectedOptionIndex: index,
      isAnswered: true,
      score: newScore,
      streak: newStreak,
      byteState: mascotState,
      speechText: speech,
    );
  }

  void setMascotState(ByteState mascotState, {String? speechText}) {
    value = value.copyWith(
      byteState: mascotState,
      speechText: speechText ?? value.speechText,
    );
  }

  void toggleHint() {
    if (value.isAnswered) return;

    final isHintShown = value.speechText == value.currentQuestion.hint;
    value = value.copyWith(
      byteState: isHintShown ? ByteState.idle : ByteState.thinking,
      speechText: isHintShown
          ? 'Tap options to submit your code!'
          : value.currentQuestion.hint,
    );
  }

  void showGuidance() {
    value = value.copyWith(
      byteState: ByteState.pointing,
      speechText: 'Select an option below to proceed! 👉',
    );
  }

  void nextQuestion() {
    if (!value.isLastQuestion) {
      final nextIndex = value.currentQuestionIndex + 1;

      value = QuizState(
        playerName: value.playerName,
        stage: value.stage,
        currentQuestionIndex: nextIndex,
        score: value.score,
        streak: value.streak,
        secondsRemaining: totalTimePerQuestion,
        byteState: ByteState.idle,
        speechText: value.streak >= 3
            ? '🔥 Streak active! Keep the code clean!'
            : 'Tap me for a hint! 💡',
      );
      _startTimer();
    }
  }

  void restartQuiz() {
    _timer?.cancel();
    value = QuizState(
      playerName: value.playerName,
      stage: value.stage,
      currentQuestionIndex: 0,
      score: 0,
      streak: 0,
      secondsRemaining: totalTimePerQuestion,
      byteState: ByteState.idle,
      speechText: 'Tap me for a hint! 💡',
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
