import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../mascot/presentation/byte_mascot.dart';
import '../data/mock_questions.dart';
import 'quiz_screen.dart';

class StageSelectScreen extends StatefulWidget {
  final String? initialPlayerName;

  const StageSelectScreen({
    super.key,
    this.initialPlayerName,
  });

  @override
  State<StageSelectScreen> createState() => _StageSelectScreenState();
}

class _StageSelectScreenState extends State<StageSelectScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedStageIndex = 0;
  ByteState _mascotState = ByteState.pointing;
  String _mascotSpeech = 'Enter your developer handle and pick a stage!';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialPlayerName ?? 'Coder';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onStageSelected(int index) {
    setState(() {
      _selectedStageIndex = index;
      _mascotState = ByteState.pointing;

      if (index == 0) {
        _mascotSpeech = 'Stage 1 chosen! Great for warming up syntax!';
      } else if (index == 1) {
        _mascotSpeech = 'Stage 2 chosen! Deep dive into functions & async!';
      } else {
        _mascotSpeech = 'Stage 3 chosen! Hardcore concurrency & memory!';
      }
    });
  }

  void _startQuest() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _mascotState = ByteState.wrong;
        _mascotSpeech = 'Please enter a developer handle!';
      });
      return;
    }

    final selectedStage = quizStages[_selectedStageIndex];

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          playerName: name,
          stage: selectedStage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ByteMascot with Dynamic Speech Text
                  Center(
                    child: ByteMascot(
                      state: _mascotState,
                      speechText: _mascotSpeech,
                      size: 110,
                      onTap: () {
                        setState(() {
                          _mascotState = ByteState.thinking;
                          _mascotSpeech = 'Choose any stage to test your coding skills!';
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Screen Title
                  Center(
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.primaryAccent,
                              AppColors.secondaryAccent,
                              AppColors.comboAccent,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'SELECT YOUR STAGE',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Configure your developer profile & difficulty',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Player Name Input Box
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEVELOPER HANDLE',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          onTap: () {
                            setState(() {
                              _mascotState = ByteState.thinking;
                              _mascotSpeech = 'Type your custom coder handle!';
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter developer name...',
                            prefixIcon: const Icon(
                              Icons.badge_rounded,
                              color: AppColors.primaryAccent,
                            ),
                            filled: true,
                            fillColor: AppColors.codeBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.cardBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primaryAccent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3 Stage Selection Cards
                  const Text(
                    'CHOOSE DIFFICULTY STAGE',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...List.generate(quizStages.length, (index) {
                    final stage = quizStages[index];
                    final isSelected = _selectedStageIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () => _onStageSelected(index),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? stage.accentColor.withValues(alpha: 0.12)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? stage.accentColor
                                  : AppColors.cardBorder,
                              width: isSelected ? 2.0 : 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: stage.accentColor.withValues(alpha: 0.25),
                                      blurRadius: 14,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              // Stage Level Badge / Emoji
                              Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.panelNavy,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: stage.accentColor.withValues(alpha: 0.6),
                                  ),
                                ),
                                child: Text(
                                  stage.iconEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Stage Title & Subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stage.title,
                                      style: TextStyle(
                                        color: isSelected
                                            ? stage.accentColor
                                            : AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      stage.description,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Checkmark icon if selected
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: stage.accentColor,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // START QUEST Button
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _startQuest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'START QUEST',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.play_arrow_rounded, size: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
