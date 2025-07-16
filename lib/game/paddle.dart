import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Paddle extends RectangleComponent
    with DragCallbacks, HasGameReference<FlameGame> {
  Paddle({
    required Vector2 position,
    required Vector2 size,
    required Paint paint,
  }) : super(position: position, size: size, paint: paint);

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final newX = position.x + event.localDelta.x;

    final leftLimit = 0.0;
    final rightLimit = game.size.x - size.x;

    position.x = newX.clamp(leftLimit, rightLimit);
  }

  @override
  void onLoad() {
    super.onLoad();
    debugPrint('Paddle Loaded!');
    add(RectangleHitbox());
  }
}
