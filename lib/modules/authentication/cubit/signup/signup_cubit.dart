import 'package:bloc/bloc.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart' show AnalyticsService;
import 'package:mywords/core/exceptions/google_failure.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/modules/authentication/repository/social_auth_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final SocialAuthRepository _socialAuthRepository;
  final SessionRepository _sessionRepository;
  final AnalyticsService _analyticsService;

  SignupCubit({
    required AuthRepository authRepository,
    required SocialAuthRepository socialAuthRepository,
    required SessionRepository sessionRepository,
    required AnalyticsService analyticsService,
  }) : _authRepository = authRepository,
       _socialAuthRepository = socialAuthRepository,
       _sessionRepository = sessionRepository,
       _analyticsService = analyticsService,
       super(SignupState.initial());

  void togglePassword() {
    emit(
      state.copyWith(signupStatus: SignupStatus.initial, isPasswordHidden: !state.isPasswordHidden),
    );
  }

  void toggleConfirmPassword() {
    emit(
      state.copyWith(
        signupStatus: SignupStatus.initial,
        isConfirmPasswordHidden: !state.isConfirmPasswordHidden,
      ),
    );
  }

  Future<void> signup(
    String fullName,
    String email,
    String password, {
    String provider = '',
  }) async {
    emit(
      state.copyWith(
        signupStatus: SignupStatus.loading,
        isGoogleLoading: provider == 'google',
        isFromGoogle: provider == 'google',
      ),
    );
    final result = await _authRepository.signup(fullName, email, password, provider);

    result.handle(
      onSuccess: (String token) async {
        if (state.isFromGoogle) {
          _analyticsService.logEvent(
            name: AnalyticsEventNames.loginWithGoogleSuccess,
            parameters: {'email': email},
          );
          await _sessionRepository.setLoggedIn(true);
          await _sessionRepository.setToken(token);
        }
        _analyticsService.logEvent(
          name: AnalyticsEventNames.signupSuccess,
          parameters: {'email': email},
        );
        emit(state.copyWith(signupStatus: SignupStatus.success, isGoogleLoading: false));
      },
      onError: (error) {
        _analyticsService.logEvent(
          name: AnalyticsEventNames.signupFailed,
          parameters: {'email': email},
        );
        emit(
          state.copyWith(
            signupStatus: SignupStatus.failed,
            errorMsg: error.errorMsg,
            isGoogleLoading: false,
            isFromGoogle: false,
          ),
        );
      },
    );
  }
}
