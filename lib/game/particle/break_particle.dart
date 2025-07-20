import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class BreakParticle extends ParticleSystemComponent {
  BreakParticle({required Vector2 position, required Vector2 size, required Color brickColor})
    : super(
        particle: Particle.generate(
          count: 20,
          lifespan: 0.4,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 600),
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
}
