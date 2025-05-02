import 'package:bloc/bloc.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/exceptions/google_failure.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/modules/authentication/repository/social_auth_repository.dart';

part 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final SocialAuthRepository _socialAuthRepository;
  final AnalyticsService _analyticsService;

  SocialAuthCubit({
    required AuthRepository authRepository,
    required SessionRepository sessionRepository,
    required SocialAuthRepository socialAuthRepository,
    required AnalyticsService analyticsService,
  }) : _authRepository = authRepository,
       _sessionRepository = sessionRepository,
       _socialAuthRepository = socialAuthRepository,
       _analyticsService = analyticsService,
       super(SocialAuthState.initial());

  void loginWithGoogle() async {
    emit(state.copyWith(socialAuthStatus: SocialAuthStatus.loading));
    try {
      final result = await _socialAuthRepository.loginWithGoogle();
      if (result.email.isNotEmpty && result.name.isNotEmpty) {
        _analyticsService.logEvent(
          name: AnalyticsEventNames.loginWithGoogleAttempt,
          parameters: {'email': result.email},
        );
        emit(
          state.copyWith(
            socialAuthStatus: SocialAuthStatus.success,
            name: result.name,
            email: result.email,
            provider: 'google',
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMsg: 'Some error occurs, Please try again',
            socialAuthStatus: SocialAuthStatus.failed,
          ),
        );
      }
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(errorMsg: e.message, socialAuthStatus: SocialAuthStatus.failed));
    } catch (c) {}
  }

  void loginWithApple() async {
    emit(state.copyWith(socialAuthStatus: SocialAuthStatus.loading));
    try {
      final result = await _socialAuthRepository.loginWithApple();
      if (result.email.isNotEmpty && result.name.isNotEmpty) {
        _analyticsService.logEvent(
          name: AnalyticsEventNames.loginWithAppleAttempt,
          parameters: {'email': result.email},
        );
        emit(
          state.copyWith(
            socialAuthStatus: SocialAuthStatus.success,
            name: result.name,
            email: result.email,
            provider: 'apple',
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMsg: 'Some error occurs, Please try again',
            socialAuthStatus: SocialAuthStatus.failed,
          ),
        );
      }
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(errorMsg: e.message, socialAuthStatus: SocialAuthStatus.failed));
    } catch (c) {}
  }
}
