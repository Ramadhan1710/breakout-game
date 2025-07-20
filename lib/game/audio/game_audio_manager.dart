import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class GameAudioManager {
  late final AudioPool hitAudioPool;
  late final AudioPool explosionAudioPool;
  late final AudioPool gameOverAudioPool;
  late final AudioPool gameWinAudioPool;

  Future<void> initializeAudioPools() async {
    explosionAudioPool = await FlameAudio.createPool(
      'explosion.mp3',
      maxPlayers: 10,
    );
    hitAudioPool = await FlameAudio.createPool('hit.mp3', maxPlayers: 10);
    gameOverAudioPool = await FlameAudio.createPool(
      'game-over.mp3',
      maxPlayers: 1,
    );
    gameWinAudioPool = await FlameAudio.createPool(
      'game-win.mp3',
      maxPlayers: 1,
    );
  }

  void dispose() {
    hitAudioPool.dispose();
    explosionAudioPool.dispose();
    gameOverAudioPool.dispose();
    gameWinAudioPool.dispose();
  }

  void playHitSound() {
    try {
      hitAudioPool.start();
    } catch (e) {
      debugPrint('Error playing hit sound: $e');
    }
  }
}
