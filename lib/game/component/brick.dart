import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../controllers/game_controller.dart';
import '../audio/game_audio_manager.dart';
import '../particle/break_particle.dart';

class Brick extends RectangleComponent with CollisionCallbacks {
  final Color brickColor;
  final GameAudioManager audioManager;
  final GameController controller;

  Brick({
    required Vector2 position,
    required Vector2 size,
    required Paint paint,
    required this.brickColor,
    required this.audioManager,
    required this.controller,
  }) : super(position: position, size: size, paint: paint);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is CircleComponent) {
      _handleCollision();
    }
  }

  Future<void> _handleCollision() async {
    audioManager.explosionAudioPool.start();
    controller.addScore(10);
    _createBreakEffect();

    final currentParent = parent;
    removeFromParent();

    // await Future.delayed(const Duration(milliseconds: 50));
    // _checkWinCondition(currentParent);
  }

  void _checkWinCondition(Component? currentParent) {
    final bricksLeft =
        currentParent?.children.whereType<Brick>().toList() ?? [];
    if (bricksLeft.isEmpty) {
      controller.gameWin();
    }
  }

  void _createBreakEffect() {
    final particle = BreakParticle(
      position: position,
      size: size,
      brickColor: brickColor,
    );

    parent?.add(particle);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = size.toRect();
    final gradient = LinearGradient(
      colors: [brickColor.withOpacity(0.9), Colors.white.withOpacity(0.3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      paint,
    );
  }
}
