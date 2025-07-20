import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
