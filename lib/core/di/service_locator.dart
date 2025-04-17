import 'package:get_it/get_it.dart';
import 'package:mywords/config/flavors/flavors.dart';
import 'package:mywords/core/network/dio_client.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/ai_detector/repository/ai_detector_repository.dart';
import 'package:mywords/modules/ai_humanizer/repository/ai_humanizer_repository.dart';
import 'package:mywords/modules/ai_writer/repository/ai_writer_repository.dart';
import 'package:mywords/modules/ai_writer/repository/file_repository.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/modules/authentication/repository/forgot_password_repository.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/modules/settings/repository/settings_repository.dart';
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
  sl.registerSingleton<DioClient>(DioClient(flavors: sl()));

  sl.registerLazySingleton<SessionRepository>(() => SessionRepository(storageService: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(dioClient: sl()));

  // AI related repositories
  sl.registerLazySingleton<AiWriterRepository>(() => AiWriterRepository(dioClient: sl()));
  sl.registerLazySingleton<AiHumanizerRepository>(() => AiHumanizerRepository(dioClient: sl()));
  sl.registerLazySingleton<AiDetectorRepository>(() => AiDetectorRepository(dioClient: sl()));

  // Misc
  sl.registerLazySingleton<ForgotPasswordRepository>(() => ForgotPasswordRepository(dioClient: sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepository(dioClient: sl()));

  // Register file repository
  sl.registerLazySingleton<FileRepository>(() => FileRepository());

  // Wait for async registrations to complete
  await sl.allReady();
}
