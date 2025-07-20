import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/game_controller.dart';
import '../../game/breakout_game.dart';
import '../widgets/three_d_button.dart';

class NextLevelOverlay extends StatelessWidget {
  final BreakoutGame game;
  final VoidCallback? onNextLevel;
  final VoidCallback? onExit;

  const NextLevelOverlay({
    super.key,
    required this.game,
    this.onNextLevel,
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
                  Icons.celebration,
                  color: Colors.greenAccent.shade400,
                  size: 64,
                  shadows: const [
                    Shadow(
                      color: Colors.green,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Level Completed!',
                  style: GoogleFonts.bungee(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
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
                    'Next Level: ${controller.currentLevel.value}',
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
                  label: "Next Level",
                  onPressed: () {
                    game.overlays.remove('NextLevelOverlay');
                    game.resumeEngine();
                  },
                  color: const Color(0xFF00FF7F), // Neon green
                ),
                const SizedBox(height: 16),
                ThreeDButton(
                  label: 'Exit',
                  onPressed: () {
                    if (onExit != null) {
                      onExit!();
                    } else {
                      game.exitGame();
                    }
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
