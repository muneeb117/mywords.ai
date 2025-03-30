import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywords/modules/authentication/pages/login_page.dart';
import 'package:mywords/modules/home/pages/home_page.dart';
import 'package:mywords/modules/onboarding/pages/onboarding_page.dart';
import 'package:mywords/modules/startup/pages/splash_page.dart';

class RouteManager {
  // Route names
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return CupertinoPageRoute(builder: (_) => const SplashPage());
      case onboarding:
        return CupertinoPageRoute(builder: (_) =>  OnboardingPage());
      case login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());
      case home:
        return CupertinoPageRoute(builder: (_) => const HomePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
