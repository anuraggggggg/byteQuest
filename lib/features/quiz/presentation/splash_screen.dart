import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import '../../mascot/presentation/byte_mascot.dart';

/// Production-Ready Motion SplashScreen for Byte Quest (3-Second Duration)
/// 4-Phase Animation Choreography:
/// Phase 1 (0.0s - 0.6s): Cinematic Entrance (Bg solid #0D1117, artwork opacity 0->1 easeIn, scale 0.93->1.0 easeOutCubic)
/// Phase 2 (0.4s - 1.4s): Title Neon Energy Sweep (-1.2 to 2.0 cyan/white shader sweep across logo)
/// Phase 3 (0.6s - 2.6s): Living Character Breathing (bob +/-5px, scale 1.0->1.015) & Floating Square Digital Particles
/// Phase 4 (2.6s - 3.0s): Exit Motion (scale 1.0->1.04, opacity 1.0->0.0) & Fade-Through Route Transition to /home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Master Timeline Animation Controller (3 Seconds = 3,000ms)
  late AnimationController _timelineController;

  // Phase 1: Cinematic Entrance Animations
  late Animation<double> _artworkOpacityAnimation;
  late Animation<double> _artworkScaleAnimation;

  // Phase 2: Title Energy Sweep Animation
  late Animation<double> _energySweepAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;

  // Phase 3: Character Procedural Idle & Particle Controllers
  late AnimationController _characterIdleController;
  late Animation<double> _characterBobAnimation;
  late Animation<double> _characterBreathAnimation;

  late AnimationController _particleController;

  // Phase 4: Exit Animations (2.6s - 3.0s)
  late Animation<double> _exitOpacityAnimation;
  late Animation<double> _exitScaleAnimation;

  // Particle data cache
  final List<_DigitalPixelParticle> _particles = [];

  static const String _bgAssetPath = 'assets/images/splash_bg.jpg';

  @override
  void initState() {
    super.initState();

    // Generate 18 digital square pixel particles with randomized properties
    final random = math.Random(42);
    for (int i = 0; i < 18; i++) {
      _particles.add(
        _DigitalPixelParticle(
          xRatio: random.nextDouble(),
          yStartRatio: 0.1 + random.nextDouble() * 1.0,
          speed: 0.4 + random.nextDouble() * 0.6,
          size: 3.0 + random.nextDouble() * 5.0,
          color: i % 2 == 0 ? AppColors.primaryAccent : AppColors.comboAccent,
          baseOpacity: 0.25 + random.nextDouble() * 0.5,
        ),
      );
    }

    // 1. Master Timeline Controller (Total Duration: 3 Seconds / 3,000ms)
    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // --- PHASE 1: Cinematic Entrance (0.0s - 0.6s -> Interval 0.0 to 0.20) ---
    _artworkOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.0, 0.20, curve: Curves.easeIn),
      ),
    );

    _artworkScaleAnimation = Tween<double>(begin: 0.93, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOutCubic),
      ),
    );

    // --- PHASE 2: Title Entrance & Neon Energy Sweep (0.4s - 1.4s -> Interval 0.133 to 0.48) ---
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.133, 0.35, curve: Curves.easeIn),
      ),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.133, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    _energySweepAnimation = Tween<double>(begin: -1.2, end: 2.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.18, 0.50, curve: Curves.easeInOut),
      ),
    );

    // --- PHASE 3: Living Character & Particle Loops ---
    _characterIdleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Vertical floating bob (±5 pixels)
    _characterBobAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _characterIdleController,
        curve: Curves.easeInOut,
      ),
    );

    // Gentle breathing scale (1.0 to 1.015)
    _characterBreathAnimation = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(
        parent: _characterIdleController,
        curve: Curves.easeInOut,
      ),
    );

    // Continuous Particle Floating Loop
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // --- PHASE 4: Exit & Page Route Transition (2.6s - 3.0s -> Interval 0.867 to 1.0) ---
    _exitOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.867, 1.0, curve: Curves.easeInOut),
      ),
    );

    _exitScaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.867, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // Handle completion at 3.0s -> Navigate to /home
    _timelineController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });

    // Start 3-Second Master Timeline
    _timelineController.forward();
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        settings: const RouteSettings(name: '/home'),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  void dispose() {
    _timelineController.dispose();
    _characterIdleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Solid #0D1117
      body: AnimatedBuilder(
        animation: _timelineController,
        builder: (context, child) {
          return Opacity(
            opacity: _exitOpacityAnimation.value,
            child: Transform.scale(
              scale: _exitScaleAnimation.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // --- PHASE 1: Cinematic Artwork Entrance ---
                  Opacity(
                    opacity: _artworkOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _artworkScaleAnimation.value,
                      child: Image.asset(
                        _bgAssetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: AppColors.background);
                        },
                      ),
                    ),
                  ),

                  // Soft Vignette Overlay to maintain visual legibility over artwork
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.75),
                          AppColors.background.withValues(alpha: 0.35),
                          AppColors.background.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),

                  // --- PHASE 3: Ambient Square Digital Particle Overlay ---
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _PixelParticlePainter(
                          particles: _particles,
                          progress: _particleController.value,
                        ),
                      );
                    },
                  ),

                  // --- MAIN UI FOREGROUND CONTENT ---
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // --- PHASE 3: Living Character Breathing & Bobbing ---
                            AnimatedBuilder(
                              animation: _characterIdleController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0.0, _characterBobAnimation.value),
                                  child: Transform.scale(
                                    scale: _characterBreathAnimation.value,
                                    child: child,
                                  ),
                                );
                              },
                              child: const ByteMascot(
                                state: ByteState.idle,
                                speechText: "Welcome to ByteQuest! Ready to level up? 🚀",
                                size: 145,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // --- PHASE 2: Title Neon Energy Sweep ---
                            FadeTransition(
                              opacity: _titleFadeAnimation,
                              child: SlideTransition(
                                position: _titleSlideAnimation,
                                child: Column(
                                  children: [
                                    // Animated ShaderMask Sweeping Cyan/White Energy across "ByteQuest"
                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        final sweep = _energySweepAnimation.value;
                                        return LinearGradient(
                                          begin: Alignment(sweep - 1.2, 0.0),
                                          end: Alignment(sweep, 0.0),
                                          colors: const [
                                            AppColors.primaryAccent,
                                            Colors.white,
                                            AppColors.primaryAccent,
                                            AppColors.comboAccent,
                                          ],
                                          stops: const [0.0, 0.45, 0.75, 1.0],
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        'ByteQuest',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 46,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 2.0,
                                          shadows: [
                                            Shadow(
                                              color: AppColors.primaryAccent,
                                              blurRadius: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Subtitle Tagline
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 1,
                                          color: AppColors.primaryAccent.withValues(alpha: 0.5),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            'LEVEL UP YOUR SYNTAX',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textSecondary,
                                              letterSpacing: 2.4,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 1,
                                          color: AppColors.primaryAccent.withValues(alpha: 0.5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Loading Status Indicator
                            const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Digital Pixel Particle Data Object
class _DigitalPixelParticle {
  final double xRatio;
  final double yStartRatio;
  final double speed;
  final double size;
  final Color color;
  final double baseOpacity;

  _DigitalPixelParticle({
    required this.xRatio,
    required this.yStartRatio,
    required this.speed,
    required this.size,
    required this.color,
    required this.baseOpacity,
  });
}

/// CustomPainter that renders floating square digital pixels (cyan & purple)
class _PixelParticlePainter extends CustomPainter {
  final List<_DigitalPixelParticle> particles;
  final double progress;

  _PixelParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = particle.xRatio * size.width;
      // Calculate upward floating y position wrapped around screen height
      final rawYRatio = particle.yStartRatio - (progress * particle.speed);
      final yRatio = ((rawYRatio % 1.2) + 1.2) % 1.2 - 0.1;
      final y = yRatio * size.height;

      // Pulse opacity near top/bottom edges
      final edgeFade = math.sin((yRatio.clamp(0.0, 1.0)) * math.pi);
      paint.color = particle.color.withValues(
        alpha: (particle.baseOpacity * edgeFade).clamp(0.0, 1.0),
      );

      // Render crisp square pixel particle
      canvas.drawRect(
        Rect.fromLTWH(x, y, particle.size, particle.size),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
