import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wall extends RectangleComponent with CollisionCallbacks {
  Wall({required Vector2 position, required Vector2 size, Paint? paint})
    : super(position: position, size: size, paint: paint ?? Paint()..color = Colors.transparent);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
