import 'package:get_it/get_it.dart';
import 'package:mywords/config/flavors/flavors.dart';
import 'package:mywords/core/network/dio_client.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/utils/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies(AppEnv appEnv) async {
  sl.registerSingleton(Flavors()..initConfig(appEnv));

  // Using async singleton to register sp
  sl.registerSingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());

  // Registering StorageService as a singleton using dependencies
  sl.registerSingletonWithDependencies<StorageService>(
    () => StorageService(preferences: sl<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  // Register network layer
  sl.registerLazySingleton<DioClient>(() => DioClient(flavors: sl()));

  // Wait for async registrations to complete
  await sl.allReady();
}