import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../game/audio/game_audio_manager.dart';

Future<void> setupDependencies() async {
  // Register GameController if not already registered
  Get.put(GameController());

  // Register GameAudioManager
  final audioManager = GameAudioManager();
  await audioManager.initializeAudioPools();
  Get.put(audioManager);
}
