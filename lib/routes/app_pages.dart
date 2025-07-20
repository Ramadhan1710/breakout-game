import 'package:get/get.dart';
import '../ui/start_screen.dart';
import '../ui/game_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.start, page: () => StartScreen()),
    GetPage(name: AppRoutes.game, page: () => GameScreen()),
  ];
}
