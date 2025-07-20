import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/game_controller.dart';

class ScoreOverlay extends StatelessWidget {
  const ScoreOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Score: ${controller.score}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.blueAccent, blurRadius: 10)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
