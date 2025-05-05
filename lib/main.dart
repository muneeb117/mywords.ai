import 'package:firebase_analytics/firebase_analytics.dart' show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mywords/config/flavors/flavors.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/config/themes/light_theme.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/bloc_setup/app_providers.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/iap/iap_configure.dart';
import 'package:mywords/core/iap/store_config.dart' show StoreConfig;
import 'package:path_provider/path_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  StoreConfig.init(store: Store.appStore, apiKey: AppKeys.appleKey);
  await IapConfig.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies(AppEnv.dev);

  runApp(MultiBlocProvider(providers: AppBlocProviders.providers, child: const MyWordsApp()));
}

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
