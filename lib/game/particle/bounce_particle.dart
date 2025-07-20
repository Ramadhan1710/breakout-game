import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class BounceParticle extends ParticleSystemComponent {
  BounceParticle({required Vector2 position})
      : super(
          position: position,
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
        );
}
