import 'package:bloc/bloc.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/exceptions/google_failure.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/modules/authentication/repository/social_auth_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final SocialAuthRepository _socialAuthRepository;
  final AnalyticsService _analyticsService;

  LoginCubit({
    required AuthRepository authRepository,
    required SessionRepository sessionRepository,
    required SocialAuthRepository socialAuthRepository,
    required AnalyticsService analyticsService,
  }) : _authRepository = authRepository,
       _sessionRepository = sessionRepository,
       _socialAuthRepository = socialAuthRepository,
       _analyticsService = analyticsService,
       super(LoginState.initial());

  void togglePassword() {
    emit(state.copyWith(loginStatus: LoginStatus.initial, isPasswordHidden: !state.isPasswordHidden));
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    final result = await _authRepository.login(email, password);

    result.handle(
      onSuccess: (String token) async {
        _analyticsService.logEvent(name: AnalyticsEventNames.loginSuccess, parameters: {'email': email});
        await _sessionRepository.setLoggedIn(true);
        await _sessionRepository.setToken(token);
        emit(state.copyWith(loginStatus: LoginStatus.success));
      },
      onError: (error) {
        _analyticsService.logEvent(name: AnalyticsEventNames.loginFailed, parameters: {'email': email});
        emit(state.copyWith(loginStatus: LoginStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(loginStatus: LoginStatus.googleLoading));
    try {
      final result = await _socialAuthRepository.loginWithGoogle();
      if (result.email.isNotEmpty && result.name.isNotEmpty) {
        _analyticsService.logEvent(name: AnalyticsEventNames.loginWithGoogleAttempt, parameters: {'email': result.email});
        emit(state.copyWith(loginStatus: LoginStatus.googleSuccess, name: result.name, email: result.email));
      } else {
        emit(state.copyWith(errorMsg: 'Some error occurs, Please try again', loginStatus: LoginStatus.failed));
      }
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(errorMsg: e.message, loginStatus: LoginStatus.failed));
    } catch (c) {}
  }
}
