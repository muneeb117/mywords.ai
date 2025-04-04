import 'package:flutter/material.dart';
import 'package:mywords/config/flavors/flavors.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/config/themes/light_theme.dart';
import 'package:mywords/core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies(AppEnv.dev);

  runApp(const MyWordsApp());
}

class MyWordsApp extends StatelessWidget {
  const MyWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWords.ai',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: lightTheme,
      initialRoute: RouteManager.splash,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}