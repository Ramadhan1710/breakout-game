import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'di/dependency_injection.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breakout Game',
      initialRoute: AppRoutes.start,
      getPages: AppPages.pages,
    );
  }
}
