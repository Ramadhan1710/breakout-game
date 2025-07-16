import 'package:breakout_game/game/breakout_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final BreakoutGame _game = BreakoutGame();

  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: _game,
    ));
  }
}
