import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'wall.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  Vector2 velocity = Vector2(200, -300);
  double speedMultiplier = 1.5;
  double rotationAngle = 0.0;
  late Paint gradientPaint;

  Ball({
    required Vector2 position,
    required double radius,
    required Paint paint,
  }) : super(position: position, radius: radius, paint: paint) {
    gradientPaint = _createGradientPaint(paint.color);
    this.paint = gradientPaint;
  }

  Paint _createGradientPaint(Color baseColor) {
    return Paint()
      ..shader = RadialGradient(
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

    rotationAngle += velocity.length * dt * 0.01;

    if (position.x <= 0) {
      position.x = 0;
      velocity.x = -velocity.x;
      _spawnBounceParticles();
    } else if (position.x + radius * 2 >= game.size.x) {
      position.x = game.size.x - radius * 2;
      velocity.x = -velocity.x;
      _spawnBounceParticles();
    }

    if (position.y <= 0) {
      position.y = 0;
      velocity.y = -velocity.y;
      _spawnBounceParticles();
    } else if (position.y + radius * 2 >= game.size.y) {
      position.y = game.size.y - radius * 2;
      velocity.y = -velocity.y;
      _spawnBounceParticles();
    }
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

    if (other is RectangleComponent || other is Wall) {
      velocity.y = -velocity.y;
      _spawnBounceParticles();
    }
  }

  void _spawnBounceParticles() {
    parent?.add(
      ParticleSystemComponent(
        position: position + Vector2(radius, radius),
        particle: Particle.generate(
          count: 6,
          lifespan: 0.2,
          generator: (i) => AcceleratedParticle(
            speed: (Vector2.random() - Vector2.random()) * 100,
            child: CircleParticle(
              radius: 1.5,
              paint: Paint()..color = Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
