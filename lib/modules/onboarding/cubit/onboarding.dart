import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/storage/storage_service.dart';

class OnboardingCubit extends Cubit<void> {
  final StorageService storageService;

  OnboardingCubit({required this.storageService}) : super(null);

  void completeOnboarding() {
    storageService.setBool(AppKeys.isNewUser, false);
  }
}
