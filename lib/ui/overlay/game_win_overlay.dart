import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../game/breakout_game.dart';
import '../../routes/app_routes.dart';
import '../widgets/three_d_button.dart';

class GameWinOverlay extends StatefulWidget {
  final BreakoutGame game;

  const GameWinOverlay({super.key, required this.game});

  @override
  State<GameWinOverlay> createState() => _GameWinOverlayState();
}

class _GameWinOverlayState extends State<GameWinOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),

        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.2,
            numberOfParticles: 15,
            shouldLoop: false,
            gravity: 0.3,
            colors: const [
              Colors.yellow,
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.purple,
              Colors.orange,
            ],
          ),
        ),

        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You Win!',
                  style: GoogleFonts.bungee(
                    fontSize: 42,
                    color: Color(0xFF00BFFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ThreeDButton(
                  label: 'Play Again',
                  onPressed: () {
                    widget.game.resetGame();
                  },
                ),
                const SizedBox(height: 16),
                ThreeDButton(
                  label: 'Exit',
                  onPressed: () {
                    Get.offAndToNamed(AppRoutes.start);
                    widget.game.resetGame();
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
