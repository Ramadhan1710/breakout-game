import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../controllers/game_controller.dart';
import 'audio/game_audio_manager.dart';
import 'component/ball.dart';
import 'component/brick.dart';
import 'component/paddle.dart';
import 'particle/background_particle.dart';

class BreakoutGame extends FlameGame with HasCollisionDetection {
  late Paddle paddle;
  late Ball ball;

  final GameController controller;
  final GameAudioManager audioManager = Get.find<GameAudioManager>();

  final List<BackgroundParticle> particles = [];
  final math.Random random = math.Random();

  static const breakoutBackgroundColor = Color(0xFF0F0F23);
  static const neonBlue = Color(0xFF00BFFF);
  static const neonPink = Color(0xFFFF1493);
  static const neonGreen = Color(0xFF00FF7F);
  static const neonYellow = Color(0xFFFFD700);
  static const neonPurple = Color(0xFF8A2BE2);

  BreakoutGame({required this.controller});

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: size);
    overlays.add('ScoreOverlay');
    _initializeParticles();
    await loadGameComponents();
    controller.isReady.value = true;
  }

  Future<void> resetGame() async {
    controller.resetGame();

    final removableComponents = children
        .where((c) => c is Ball || c is Paddle || c is Brick)
        .toList();

    await Future.wait(
      removableComponents.map((c) async => c.removeFromParent()),
    );

    overlays.remove('GameOverOverlay');
    overlays.remove('GameWinOverlay');

    await loadGameComponents();
    resumeEngine();
  }

  void exitGame() {
    controller.resetGame();
    overlays.remove('GameOverOverlay');
    overlays.remove('GameWinOverlay');
    Get.offAndToNamed('/start');
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

  Future<void> _createEnhancedBricks(
    double screenWidth,
    double screenHeight,
    double levelFactor,
  ) async {
    final brickWidth = screenWidth / 11;
    const brickHeight = 30.0;
    final gap = brickWidth * 0.1;
    const columns = 5;
    int rows = 2 + (controller.currentLevel.value - 1);
    if (rows > 6) rows = 6;

    final startX = (screenWidth - ((brickWidth + gap) * columns - gap)) / 2;
    const startY = 60.0;

    final colors = [
      neonPurple,
      neonBlue,
      neonGreen,
      neonYellow,
      neonPink,
      Colors.orange,
    ];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final x = startX + col * (brickWidth + gap);
        final y = startY + row * (brickHeight + gap);
        final baseColor = colors[row % colors.length];
        final brickColor = Color.lerp(
          baseColor,
          Colors.white,
          (col / columns) * 0.3,
        )!;

        final brick = Brick(
          audioManager: audioManager,
          controller: controller,
          position: Vector2(x, y),
          size: Vector2(brickWidth, brickHeight),
          paint: Paint()..color = brickColor,
          brickColor: brickColor,
        );
        await add(brick);
      }
    }
  }

  Future<void> nextLevel() async {
    if (controller.currentLevel.value < controller.maxLevel.value) {
      controller.increaseLevel();
      controller.isLoadingLevel.value = true;
      controller.resetForNextLevel();

      final removable = children
          .where((c) => c is Ball || c is Paddle || c is Brick)
          .toList();
      await Future.wait(removable.map((c) async => c.removeFromParent()));

      await loadGameComponents();

      overlays.add('NextLevelOverlay'); // Munculkan overlay naik level
      pauseEngine();

      controller.isLoadingLevel.value = false;
    } else {
      _handleGameWin();
    }
  }

  void _handleGameOver() {
    pauseEngine();
    audioManager.gameOverAudioPool.start();
    overlays.add('GameOverOverlay');
  }

  void _handleGameWin() {
    pauseEngine();
    audioManager.gameWinAudioPool.start();
    overlays.add('GameWinOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final particle in particles) {
      particle.update(dt, size);
    }

    final bricks = children.whereType<Brick>().toList();

    if (!controller.isLoadingLevel.value &&
        !controller.isGameOver.value &&
        !controller.isGameWin.value &&
        bricks.isEmpty) {
      nextLevel();
    }

    if (controller.isGameOver.value && !overlays.isActive('GameOverOverlay')) {
      _handleGameOver();
    }

    if (controller.isGameWin.value && !overlays.isActive('GameWinOverlay')) {
      _handleGameWin();
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

  Future<void> loadGameComponents() async {
    final screenWidth = size.x;
    final screenHeight = size.y;
    final levelFactor = 1.0 + (controller.currentLevel.value - 1) * 0.25;

    paddle = Paddle(
      controller: controller,
      position: Vector2(screenWidth / 2 - 60, screenHeight - 40),
      size: Vector2(screenWidth * 0.3 / levelFactor, 25),
      paint: Paint()..color = neonBlue,
    );
    await add(paddle);

    ball = Ball(
      audioManager: audioManager,
      controller: controller,
      position: Vector2(screenWidth / 2, screenHeight / 2),
      radius: screenWidth * 0.03,
      paint: Paint()..color = neonPink,
      speedMultiplier: 1.0 * levelFactor,
    );
    await add(ball);

    await _createEnhancedBricks(screenWidth, screenHeight, levelFactor);

    ball.resetVelocity();
  }

  void _drawAnimatedBackground(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        breakoutBackgroundColor,
        breakoutBackgroundColor.withOpacity(0.8),
        const Color(0xFF1A1A3A),
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
      ..strokeWidth = 1.0;

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
