import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/config/flavors/flavors.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/config/themes/light_theme.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/modules/ai_writer/cubit/file_import/file_import_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies(AppEnv.dev);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AiWriterCubit(aiWriterRepository: sl()),
        ),
        BlocProvider(
          create: (_) => FileImportCubit(fileRepository: sl()),
        ),
      ],
      child: const MyWordsApp(),
    ),
  );
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
