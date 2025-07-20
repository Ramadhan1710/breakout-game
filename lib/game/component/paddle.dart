import 'package:breakout_game/controllers/game_controller.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Paddle extends RectangleComponent
    with DragCallbacks, HasGameReference<FlameGame> {
  late double leftLimit;
  late double rightLimit;
  late double upperLimit;
  late double lowerLimit;
  final GameController controller;

  Paddle({
    required Vector2 position,
    required Vector2 size,
    required Paint paint,
    required this.controller,
  }) : super(position: position, size: size, paint: paint);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugPrint('Paddle Loaded!');

    leftLimit = 0.0;
    rightLimit = game.size.x - size.x;
    upperLimit = game.size.y - 150;
    lowerLimit = game.size.y - 20;

    add(RectangleHitbox());
    controller.isReady.value = true;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    leftLimit = 0.0;
    rightLimit = size.x - this.size.x;
    upperLimit = size.y - 150;
    lowerLimit = size.y - 20;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    final gradient = LinearGradient(
      colors: [Colors.lightBlueAccent, Colors.white.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(12)), paint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.inflate(4), Radius.circular(16)),
      Paint()
        ..color = Colors.lightBlueAccent.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (controller.isReady.value == false) return;
    final double newX = position.x + event.localDelta.x;
    final double newY = position.y + event.localDelta.y;

    position.x = newX.clamp(leftLimit, rightLimit);
    position.y = newY.clamp(upperLimit, lowerLimit);
  }
}
