import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/game_controller.dart';
import '../../game/breakout_game.dart';
import '../../routes/app_routes.dart';
import '../widgets/three_d_button.dart';

class GameOverOverlay extends StatelessWidget {
  final BreakoutGame game;
  final VoidCallback? onRestart;
  final VoidCallback? onExit;

  const GameOverOverlay({
    super.key,
    required this.game,
    this.onRestart,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.1)),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D1E33), Color(0xFF111123)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(1, 1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  offset: const Offset(-4, -4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.redAccent.shade200,
                  size: 64,
                  shadows: const [
                    Shadow(
                      color: Colors.red,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Game Over!',
                  style: GoogleFonts.bungee(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    shadows: const [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 6,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    'Your Score: ${controller.score}',
                    style: GoogleFonts.orbitron(
                      fontSize: 22,
                      color: Colors.white70,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ThreeDButton(
                  label: "Restart",
                  onPressed: () {
                    if (onRestart != null) {
                      onRestart!();
                    } else {
                      controller.resetGame();
                      game.resetGame();
                    }
                  },
                  color: const Color(
                    0xFF00BFFF,
                  ), // Default color for the button
                ),
                const SizedBox(height: 16),
                ThreeDButton(
                  label: 'Exit',
                  onPressed: () {
                    game.exitGame();
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
