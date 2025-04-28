import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';

enum OnboardingCompletionType { skipped, completed }

class OnboardingCubit extends Cubit<void> {
  final SessionRepository _sessionRepository;
  final AnalyticsService _analyticsService;

  OnboardingCubit({required SessionRepository sessionRepository, required AnalyticsService analyticsService})
    : _sessionRepository = sessionRepository,
      _analyticsService = analyticsService,
      super(null);

  void complete(OnboardingCompletionType completionType) {
    switch (completionType) {
      case OnboardingCompletionType.skipped:
        _analyticsService.logEvent(name: AnalyticsEventNames.onboardingSkipped);
        break;
      case OnboardingCompletionType.completed:
        _analyticsService.logEvent(name: AnalyticsEventNames.onboardingCompleted);
        break;
    }
    _sessionRepository.completeOnboarding();
  }
}