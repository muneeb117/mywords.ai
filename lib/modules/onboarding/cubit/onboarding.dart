import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mywords/modules/authentication/repository/session_repository.dart';

class OnboardingCubit extends Cubit<void> {
  final SessionRepository _sessionRepository;

  OnboardingCubit({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(null);

  void complete() {
    _sessionRepository.completeOnboarding();
  }
}