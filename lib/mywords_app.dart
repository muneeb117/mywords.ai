import 'package:firebase_analytics/firebase_analytics.dart' show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/config/themes/light_theme.dart';
import 'package:mywords/core/di/service_locator.dart' show sl;

class MyWordsApp extends StatelessWidget {
  const MyWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return MaterialApp(
          title: 'MyWords.ai',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: lightTheme,
          navigatorObservers: <NavigatorObserver>[
            FirebaseAnalyticsObserver(analytics: sl<FirebaseAnalytics>()),
          ],
          initialRoute: RouteManager.splash,
          onGenerateRoute: RouteManager.generateRoute,
        );
      },
    );
  }
}
