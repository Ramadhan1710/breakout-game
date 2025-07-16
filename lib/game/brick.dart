import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class Brick extends RectangleComponent with CollisionCallbacks {
  final Color brickColor;
  Brick({
    required Vector2 position,
    required Vector2 size,
    required Paint paint,
    required this.brickColor,
  }) : super(position: position, size: size, paint: paint);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is CircleComponent) {
      _createBreakEffect();
      removeFromParent(); // Remove brick on collision
    }
  }

  void _createBreakEffect() {
  final particle = ParticleSystemComponent(
    particle: Particle.generate(
      count: 20,
      lifespan: 0.4,
      generator: (i) => AcceleratedParticle(
        acceleration: Vector2(0, 600), // Gravity effect
        speed: (Vector2.random() - Vector2.random()) * 200,
        position: size / 2,
        child: CircleParticle(
          radius: 2,
          paint: Paint()..color = brickColor,
        ),
      ),
    ),
    position: position + size / 2,
  );

  parent?.add(particle); // Tambahkan ke parent dari brick
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

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(6)), paint);
  }
}
