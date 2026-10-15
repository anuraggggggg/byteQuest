import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// ByteState enum defining visual states for the ByteMascot character.
enum ByteState {
  idle,
  thinking,
  correct,
  wrong,
  pointing,
}

extension ByteStateAsset on ByteState {
  /// Strict PNG asset path mapping for each mascot state
  String get assetPath {
    switch (this) {
      case ByteState.idle:
        return 'assets/images/codie/neutral.png';
      case ByteState.thinking:
        return 'assets/images/codie/thinking.png';
      case ByteState.correct:
        return 'assets/images/codie/correct.png';
      case ByteState.wrong:
        return 'assets/images/codie/wrong.png';
      case ByteState.pointing:
        return 'assets/images/codie/neutral.png'; // Fallback to neutral if pointing artwork absent
    }
  }

  /// Backup fallback asset path
  String get fallbackAssetPath {
    switch (this) {
      case ByteState.idle:
      case ByteState.pointing:
        return 'assets/images/codie/neutral.png';
      case ByteState.thinking:
        return 'assets/images/codie/thinking_codie.jpeg';
      case ByteState.correct:
        return 'assets/images/codie/correct_answer.png';
      case ByteState.wrong:
        return 'assets/images/codie/wrong_answer.png';
    }
  }

  Color get glowColor {
    switch (this) {
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
}

/// Reusable ByteMascot widget implementing native Flutter 2D animations
/// (idle float, breathing, blinking, thinking pulse, celebration jump & particles, wrong shake).
class ByteMascot extends StatefulWidget {
  final ByteState state;
  final String? speechText;
  final VoidCallback? onTap;
  final double size;

  const ByteMascot({
    super.key,
    required this.state,
    this.speechText,
    this.onTap,
    this.size = 120,
  });

  @override
  State<ByteMascot> createState() => _ByteMascotState();
}

class _ByteMascotState extends State<ByteMascot>
    with TickerProviderStateMixin {
  // 1. Idle & Breathing & Head Tilt Loop
  late AnimationController _idleController;
  late Animation<double> _bobAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _tiltAnimation;

  // 2. Procedural Blink Effect Loop (Simulated eyelid blink overlay)
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  Timer? _blinkTimer;

  // 3. Celebration Bounce, Scale Burst, & Spin (Correct)
  late AnimationController _correctController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleBurstAnimation;

  // 4. Shake & Squish-Stretch (Wrong)
  late AnimationController _wrongController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _squishXAnimation;
  late Animation<double> _squishYAnimation;

  // 5. Particle FX Ring Controller
  late AnimationController _particleFxController;

  @override
  void initState() {
    super.initState();

    // Idle continuous float, breathing pulse & head tilt
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _bobAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );

    _breathAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );

    _tiltAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );

    // Occasional Blinking Loop
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    _scheduleNextBlink();

    // Celebration Jump (Correct)
    _correctController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -26.0).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 45),
      TweenSequenceItem(tween: Tween<double>(begin: -26.0, end: 0).chain(CurveTween(curve: Curves.bounceOut)), weight: 55),
    ]).animate(_correctController);

    _scaleBurstAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.20).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.20, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 60),
    ]).animate(_correctController);

    // Shake & Squish (Wrong)
    _wrongController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 14.0), weight: 15),
      TweenSequenceItem(tween: Tween<double>(begin: 14.0, end: -14.0), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: -14.0, end: 8.0), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 8.0, end: -4.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -4.0, end: 0), weight: 15),
    ]).animate(CurvedAnimation(parent: _wrongController, curve: Curves.easeInOut));

    _squishXAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.20), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 1.20, end: 0.88), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 0.88, end: 1.0), weight: 40),
    ]).animate(_wrongController);

    _squishYAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.82), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 0.82, end: 1.18), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.18, end: 1.0), weight: 40),
    ]).animate(_wrongController);

    // Particle FX Controller
    _particleFxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _triggerStateAnimation(widget.state);
  }

  void _scheduleNextBlink() {
    _blinkTimer?.cancel();
    // Random blink every 3 to 6 seconds
    final delay = Duration(milliseconds: 3000 + math.Random().nextInt(3000));
    _blinkTimer = Timer(delay, () {
      if (mounted) {
        _blinkController.forward().then((_) {
          if (mounted) {
            _blinkController.reverse().then((_) => _scheduleNextBlink());
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ByteMascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _triggerStateAnimation(widget.state);
    }
  }

  void _triggerStateAnimation(ByteState state) {
    if (state == ByteState.correct) {
      _correctController.forward(from: 0.0);
    } else if (state == ByteState.wrong) {
      _wrongController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _idleController.dispose();
    _blinkController.dispose();
    _correctController.dispose();
    _wrongController.dispose();
    _particleFxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glow = widget.state.glowColor;

    return GestureDetector(
      onTap: () {
        _correctController.forward(from: 0.0);
        widget.onTap?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech Bubble above mascot (if provided)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: widget.speechText != null && widget.speechText!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _ByteSpeechBubble(
                      text: widget.speechText!,
                      accentColor: glow,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Main Character Widget Box
          SizedBox(
            width: widget.size + 24,
            height: widget.size + 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Particle Sparks & Expression Rings Overlay
                AnimatedBuilder(
                  animation: _particleFxController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size + 20, widget.size + 20),
                      painter: _ByteParticleFxPainter(
                        state: widget.state,
                        progress: _particleFxController.value,
                        glowColor: glow,
                      ),
                    );
                  },
                ),

                // 2. Character Body Transform Stack
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _idleController,
                    _correctController,
                    _wrongController,
                  ]),
                  builder: (context, child) {
                    final double translateY = _bobAnimation.value + _bounceAnimation.value;
                    final double translateX = _shakeAnimation.value;

                    final double scaleX = _breathAnimation.value *
                        _scaleBurstAnimation.value *
                        (_wrongController.isAnimating ? _squishXAnimation.value : 1.0);

                    final double scaleY = _breathAnimation.value *
                        _scaleBurstAnimation.value *
                        (_wrongController.isAnimating ? _squishYAnimation.value : 1.0);

                    final double tiltAngle = _tiltAnimation.value +
                        (widget.state == ByteState.pointing ? 0.08 : 0.0) +
                        (widget.state == ByteState.thinking ? -0.06 : 0.0);

                    return Transform.translate(
                      offset: Offset(translateX, translateY),
                      child: Transform.rotate(
                        angle: tiltAngle,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.diagonal3Values(scaleX, scaleY, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: glow.withValues(alpha: 0.45),
                          blurRadius: 24,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // PNG Image Asset Switcher
                        ClipRRect(
                          borderRadius: BorderRadius.circular(widget.size / 2),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeOutBack,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Image.asset(
                              widget.state.assetPath,
                              key: ValueKey<String>(widget.state.assetPath),
                              width: widget.size,
                              height: widget.size,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  widget.state.fallbackAssetPath,
                                  key: ValueKey<String>(widget.state.fallbackAssetPath),
                                  width: widget.size,
                                  height: widget.size,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _FallbackMascotIcon(state: widget.state, size: widget.size);
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        // Procedural Eye Blink Overlay for IDLE/POINTING states
                        if (widget.state == ByteState.idle || widget.state == ByteState.pointing)
                          AnimatedBuilder(
                            animation: _blinkAnimation,
                            builder: (context, child) {
                              if (_blinkAnimation.value == 0) return const SizedBox.shrink();
                              return Positioned(
                                top: widget.size * 0.38,
                                left: widget.size * 0.28,
                                right: widget.size * 0.28,
                                height: widget.size * 0.12 * _blinkAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E2235),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ByteSpeechBubble extends StatelessWidget {
  final String text;
  final Color accentColor;

  const _ByteSpeechBubble({
    required this.text,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 270),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.85),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.25),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(14, 8),
          painter: _SpeechPointerPainter(color: accentColor),
        ),
      ],
    );
  }
}

class _SpeechPointerPainter extends CustomPainter {
  final Color color;

  _SpeechPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeechPointerPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ByteParticleFxPainter extends CustomPainter {
  final ByteState state;
  final double progress;
  final Color glowColor;

  _ByteParticleFxPainter({
    required this.state,
    required this.progress,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (state == ByteState.correct) {
      final particlePaint = Paint()..style = PaintingStyle.fill;
      for (int i = 0; i < 6; i++) {
        final angle = (i * math.pi / 3) + (progress * 2 * math.pi);
        final distance = radius - 4 + (math.sin(progress * 2 * math.pi + i) * 6);
        final x = center.dx + distance * math.cos(angle);
        final y = center.dy + distance * math.sin(angle);

        particlePaint.color = (i % 2 == 0 ? AppColors.primaryAccent : glowColor)
            .withValues(alpha: 0.7 + (math.sin(progress * math.pi * 2 + i) * 0.3));

        canvas.drawCircle(Offset(x, y), 3.5, particlePaint);
      }
    } else if (state == ByteState.wrong) {
      final alertPaint = Paint()
        ..color = AppColors.errorCrimson.withValues(alpha: 0.3 + (math.sin(progress * math.pi * 4) * 0.2))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius - 2, alertPaint);
    } else if (state == ByteState.thinking) {
      final dotPaint = Paint()..color = AppColors.secondaryAccent.withValues(alpha: 0.6);
      for (int i = 0; i < 4; i++) {
        final angle = (i * math.pi / 2) - (progress * 2 * math.pi);
        final x = center.dx + (radius - 6) * math.cos(angle);
        final y = center.dy + (radius - 6) * math.sin(angle);
        canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ByteParticleFxPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.state != state;
}

class _FallbackMascotIcon extends StatelessWidget {
  final ByteState state;
  final double size;

  const _FallbackMascotIcon({required this.state, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.panelNavy,
        shape: BoxShape.circle,
        border: Border.all(color: state.glowColor, width: 2),
      ),
      child: Icon(
        state == ByteState.correct
            ? Icons.emoji_events_rounded
            : state == ByteState.wrong
                ? Icons.bug_report_rounded
                : state == ByteState.pointing
                    ? Icons.touch_app_rounded
                    : state == ByteState.thinking
                        ? Icons.psychology_rounded
                        : Icons.smart_toy_rounded,
        size: size * 0.5,
        color: state.glowColor,
      ),
    );
  }
}
