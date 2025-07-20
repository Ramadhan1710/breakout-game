import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/app_routes.dart';
import 'dart:math' as math;

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Glowing orbs background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: GlowingOrbsPainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Game title with custom paint
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: CustomPaint(
                              painter: TitlePainter(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                child: Text(
                                  'BREAKOUT',
                                  style: GoogleFonts.pressStart2p(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 8,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF00d4aa),
                                        offset: Offset(0, 0),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Subtitle
                          Text(
                            'GAME',
                            style: GoogleFonts.bungee(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 6,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Play button with custom design
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.game);
                            },
                            child: SizedBox(
                              width: 250,
                              height: 60,
                              child: CustomPaint(
                                painter: PlayButtonPainter(),
                                child: Center(
                                  child: Text(
                                    'PLAY GAME',
                                    style: GoogleFonts.pressStart2p(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Decorative elements
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF00d4aa),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00d4aa),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00d4aa),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 50,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00d4aa),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00d4aa).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = (size.width * (i * 0.1 + animationValue * 0.5)) % size.width;
      final y = (size.height * (i * 0.07 + animationValue * 0.3)) % size.height;
      final radius = math.sin(animationValue * 2 * math.pi + i) * 2 + 3;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GlowingOrbsPainter extends CustomPainter {
  final double animationValue;
  
  GlowingOrbsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    // Large glowing orb
    paint.color = const Color(0xFF00d4aa).withOpacity(0.1);
    final orb1X = size.width * 0.2 + math.sin(animationValue * 2 * math.pi) * 50;
    final orb1Y = size.height * 0.3 + math.cos(animationValue * 2 * math.pi) * 30;
    canvas.drawCircle(Offset(orb1X, orb1Y), 80, paint);

    // Second orb
    paint.color = const Color(0xFF533483).withOpacity(0.08);
    final orb2X = size.width * 0.8 + math.cos(animationValue * 1.5 * math.pi) * 40;
    final orb2Y = size.height * 0.7 + math.sin(animationValue * 1.5 * math.pi) * 60;
    canvas.drawCircle(Offset(orb2X, orb2Y), 100, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TitlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00d4aa).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(15),
    );

    canvas.drawRRect(rect, paint);

    // Add corner decorations
    final cornerPaint = Paint()
      ..color = const Color(0xFF00d4aa)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(15, 15), 3, cornerPaint);
    canvas.drawCircle(Offset(size.width - 15, 15), 3, cornerPaint);
    canvas.drawCircle(Offset(15, size.height - 15), 3, cornerPaint);
    canvas.drawCircle(Offset(size.width - 15, size.height - 15), 3, cornerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PlayButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Gradient background
    final gradient = LinearGradient(
      colors: [
        const Color(0xFF533483),
        const Color(0xFF00d4aa),
      ],
    ).createShader(rect);

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(30));
    canvas.drawRRect(rrect, paint);

    // Border
    final borderPaint = Paint()
      ..color = const Color(0xFF00d4aa)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(rrect, borderPaint);

    // Glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFF00d4aa).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}