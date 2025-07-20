import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../controllers/game_controller.dart';
import '../audio/game_audio_manager.dart';
import '../particle/bounce_particle.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  static final Vector2 initialVelocity = Vector2(200, -300);

  static const double rotationSpeedFactor = 0.01;

  late Paint gradientPaint;

  final GameAudioManager audioManager;
  final GameController controller;
  final double speedMultiplier;

  Vector2 velocity = initialVelocity;
  double rotationAngle = 0.0;

  Ball({
    required Vector2 position,
    required double radius,
    required Paint paint,
    required this.audioManager,
    required this.controller,
    required this.speedMultiplier,
  }) : super(position: position, radius: radius, paint: paint) {
    gradientPaint = _createGradientPaint(paint.color);
    this.paint = gradientPaint;
  }

  Vector2 get centerPosition => position + Vector2(radius, radius);

  void resetVelocity() {
    velocity = Vector2(200, -300);
  }

  Paint _createGradientPaint(Color baseColor) {
    return Paint()
      ..shader =
          RadialGradient(
            colors: [
              baseColor,
              baseColor.withOpacity(0.6),
              baseColor.withOpacity(0.4),
              Colors.white.withOpacity(0.2),
            ],
            center: Alignment.topLeft,
            radius: 0.9,
          ).createShader(
            Rect.fromCircle(center: Offset(radius, radius), radius: radius),
          );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt * speedMultiplier;

    rotationAngle += velocity.length * dt * rotationSpeedFactor;

    _checkBoundsAndBounce();
  }

  void _checkBoundsAndBounce() {
    if (position.x <= 0) {
      _bounceXAt(0);
    } else if (position.x + radius * 2 >= game.size.x) {
      _bounceXAt(game.size.x - radius * 2);
    }

    if (position.y <= 0) {
      _bounceYAt(0);
    } else if (position.y + radius * 2 >= game.size.y) {
      position.y = game.size.y - radius * 2;
      velocity.y = -velocity.y;
      controller.gameOver();
    }
  }

  void _bounceXAt(double x) {
    playHitSound();
    position.x = x;
    velocity.x = -velocity.x;
    _spawnBounceParticles();
  }

  void _bounceYAt(double y) {
    playHitSound();
    position.y = y;
    velocity.y = -velocity.y;
    _spawnBounceParticles();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(rotationAngle);
    canvas.translate(-radius, -radius);
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.restore();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is RectangleComponent) {
      playHitSound();
      velocity.y = -velocity.y;
      _spawnBounceParticles();
    }
  }

  void _spawnBounceParticles() {
    parent?.add(BounceParticle(position: centerPosition));
  }

  void playHitSound() {
    audioManager.playHitSound();
  }
}
