import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/cubits/file_import/file_import_cubit.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/modules/authentication/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:mywords/modules/home/cubit/home_cubit.dart';
import 'package:mywords/modules/paywall/cubit/paywall_cubit.dart';

class AppBlocProviders {
  static List<BlocProvider> providers = [
    BlocProvider<PaywallCubit>(create: (_) => PaywallCubit(iapService: sl())),
    BlocProvider<AiWriterCubit>(create: (_) => AiWriterCubit(aiWriterRepository: sl(), analyticsService: sl())),
    BlocProvider<AiHumanizerCubit>(create: (_) => AiHumanizerCubit(aiHumanizerRepository: sl(), analyticsService: sl())),
    BlocProvider<AiDetectorCubit>(create: (_) => AiDetectorCubit(aiDetectorRepository: sl(), analyticsService: sl())),
    BlocProvider<FileImportCubit>(create: (_) => FileImportCubit(fileRepository: sl())),
    BlocProvider<ForgotPasswordCubit>(create: (_) => ForgotPasswordCubit(forgotPasswordRepository: sl(), analyticsService: sl())),
    BlocProvider<HomeCubit>(create: (_) => HomeCubit(homeRepository: sl())..fetchDocumentHours()),
  ];
}
