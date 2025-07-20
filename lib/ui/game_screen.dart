import 'package:breakout_game/game/breakout_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_controller.dart';
import 'overlay/game_over_overlay.dart';
import 'overlay/game_win_overlay.dart';
import 'overlay/next_level_overlay.dart';
import 'overlay/score_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BreakoutGame _game;
  late GameController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GameController>();
    _game = BreakoutGame(
      controller: controller,
    );
  }

  @override
  void dispose() {
    _game.onDetach();
    for (var component in _game.children) {
      component.removeFromParent();
    }
    _game.removeFromParent();
    super.dispose();
  }

  void resetGame() {
    // Hapus game lama dulu biar gak nimbun
    _game.onDetach();
    for (var component in _game.children) {
      component.removeFromParent();
    }
    _game.removeFromParent();

    // Buat instance baru dan reset controller
    setState(() {
      _game = BreakoutGame(
        controller: controller,
      );
      controller.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        key: ValueKey(_game.hashCode), // <-- Kunci biar game lama dispose
        game: _game,
        overlayBuilderMap: {
          'ScoreOverlay': (context, game) => const ScoreOverlay(),
          'GameOverOverlay': (context, game) => GameOverOverlay(
                game: _game,
                onExit: resetGame,
                onRestart: resetGame,
              ),
          'GameWinOverlay': (context, game) => GameWinOverlay(game: _game),
          'NextLevelOverlay': (context, game) => NextLevelOverlay(
                game: _game,
                onNextLevel: () {
                  resetGame();
                },
                onExit: resetGame,
              ),
        },
        initialActiveOverlays: const ['ScoreOverlay'],
      ),
    );
  }
}
