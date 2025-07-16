import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'ball.dart';
import 'brick.dart';
import 'paddle.dart';
import 'wall.dart';

class BreakoutGame extends FlameGame with HasCollisionDetection {
  late Paddle paddle;
  late Ball ball;
  late Brick brick;
  late Wall wall;

  final List<BackgroundParticle> particles = [];
  final math.Random random = math.Random();

  static const Color breakoutBackgroundColor = Color(0xFF0F0F23);
  static const Color neonBlue = Color(0xFF00BFFF);
  static const Color neonPink = Color(0xFFFF1493);
  static const Color neonGreen = Color(0xFF00FF7F);
  static const Color neonYellow = Color(0xFFFFD700);
  static const Color neonPurple = Color(0xFF8A2BE2);

  @override
  Future<void> onLoad() async {
    debugPrint('Enhanced BreakoutGame Loaded!');

    camera.viewport = FixedResolutionViewport(resolution: size);

    _initializeParticles();

    final screenWidth = size.x;
    final screenHeight = size.y;

    paddle = Paddle(
      position: Vector2(screenWidth / 2 - 60, screenHeight - 40),
      size: Vector2(screenWidth * 0.3, 25),
      paint: Paint()
        ..color = neonBlue
        ..style = PaintingStyle.fill,
    );

    add(paddle);

    ball = Ball(
      position: Vector2(screenWidth / 2, screenHeight / 2),
      radius: screenWidth * 0.03,
      paint: Paint()
        ..color = neonPink
        ..style = PaintingStyle.fill,
    );

    add(ball);

    _createEnhancedBricks(screenWidth, screenHeight);
  }

  void _initializeParticles() {
    for (int i = 0; i < 50; i++) {
      particles.add(
        BackgroundParticle(
          position: Vector2(
            random.nextDouble() * size.x,
            random.nextDouble() * size.y,
          ),
          velocity: Vector2(
            (random.nextDouble() - 0.5) * 20,
            (random.nextDouble() - 0.5) * 20,
          ),
          color: [
            neonBlue,
            neonPink,
            neonGreen,
            neonYellow,
            neonPurple,
          ][random.nextInt(5)],
          size: random.nextDouble() * 3 + 1,
        ),
      );
    }
  }

  void _createEnhancedBricks(double screenWidth, double screenHeight) {
    final brickWidth = screenWidth / 11;
    final brickHeight = 30.0;
    final gap = brickWidth * 0.1;
    final columns = 10;
    final rows = 6;
    final startX = (screenWidth - ((brickWidth + gap) * columns - gap)) / 2;
    final startY = 60.0;

    final colors = [
      neonPurple,
      neonBlue,
      neonGreen,
      neonYellow,
      neonPink,
      Colors.orange,
    ];

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < columns; col++) {
        final x = startX + col * (brickWidth + gap);
        final y = startY + row * (brickHeight + gap);

        final baseColor = colors[row % colors.length];
        final brickColor = Color.lerp(
          baseColor,
          Colors.white,
          (col / columns) * 0.3,
        )!;

        final brick = Brick(
          position: Vector2(x, y),
          size: Vector2(brickWidth, brickHeight),
          paint: Paint()
            ..color = brickColor
            ..style = PaintingStyle.fill,
          brickColor: brickColor,
        );

        add(brick);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final particle in particles) {
      particle.update(dt, size);
    }
  }

  @override
  void render(Canvas canvas) {
    _drawAnimatedBackground(canvas);

    for (final particle in particles) {
      particle.render(canvas);
    }

    _drawGlowEffects(canvas);

    super.render(canvas);
  }

  void _drawAnimatedBackground(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        breakoutBackgroundColor,
        breakoutBackgroundColor.withOpacity(0.8),
        Color(0xFF1A1A3A),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);

    _drawGrid(canvas);
  }

  void _drawGrid(Canvas canvas) {
    final paint = Paint()
      ..color = neonBlue.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 40.0;

    for (double x = 0; x <= size.x; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), paint);
    }

    for (double y = 0; y <= size.y; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), paint);
    }
  }

  void _drawGlowEffects(Canvas canvas) {
    final glowPaint = Paint()
      ..color = neonBlue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8.0);

    final gameRect = Rect.fromLTWH(20, 20, size.x - 40, size.y - 40);
    canvas.drawRect(gameRect, glowPaint);
  }
}

class BackgroundParticle {
  Vector2 position;
  Vector2 velocity;
  Color color;
  double size;
  double opacity = 1.0;

  BackgroundParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
  });

  void update(double dt, Vector2 gameSize) {
    position += velocity * dt;

    if (position.x < 0) position.x = gameSize.x;
    if (position.x > gameSize.x) position.x = 0;
    if (position.y < 0) position.y = gameSize.y;
    if (position.y > gameSize.y) position.y = 0;

    opacity = (math.sin(DateTime.now().millisecondsSinceEpoch * 0.002) + 1) / 2;
  }

  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color.withOpacity(opacity * 0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(position.x, position.y), size, paint);
  }
}
