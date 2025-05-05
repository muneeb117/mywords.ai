import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mywords/config/flavors/flavors.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/bloc_setup/app_providers.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/iap/iap_configure.dart';
import 'package:mywords/core/iap/store_config.dart' show StoreConfig;
import 'package:mywords/mywords_app.dart' show MyWordsApp;
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
