import 'package:flutter/material.dart';
import 'package:mywords/config/themes/dark_theme.dart';
import 'package:mywords/config/themes/light_theme.dart';
import 'package:mywords/modules/startup/pages/splash_page.dart';

void main() {
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
      darkTheme: darkTheme,
      home: const SplashPage(),
    );
  }
}