import 'package:get/get.dart';

class GameController extends GetxController {
  RxInt score = 0.obs;
  RxInt lives = 3.obs;
  RxBool isGameOver = false.obs;
  RxBool isGameWin = false.obs;
  RxInt currentLevel = 1.obs;
  RxInt maxLevel = 2.obs;
  RxBool isLoadingLevel = false.obs;
  RxBool isReady = false.obs;

  void addScore(int value) {
    score += value;
  }

  void gameOver() {
    isGameOver.value = true;
  }

  void gameWin() {
    isGameWin.value = true;
  }

  void resetGame() {
    score.value = 0;
    currentLevel.value = 1;
    lives.value = 3;
    isGameOver.value = false;
    isGameWin.value = false;
  }

  void resetForNextLevel() {
    isGameOver.value = false;
    isGameWin.value = false;
  }

  void increaseLevel() {
    if (currentLevel.value < maxLevel.value) {
      currentLevel.value++;
    } else {
      gameWin();
    }
  }
}
