import 'package:bloc/bloc.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/iap/iap_service.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final IapService _iapService;
  final AnalyticsService _analyticsService;

  LoginCubit({
    required AuthRepository authRepository,
    required SessionRepository sessionRepository,
    required IapService iapService,
    required AnalyticsService analyticsService,
  }) : _authRepository = authRepository,
       _sessionRepository = sessionRepository,
       _iapService = iapService,
       _analyticsService = analyticsService,
       super(LoginState.initial());

  void togglePassword() {
    emit(
      state.copyWith(loginStatus: LoginStatus.initial, isPasswordHidden: !state.isPasswordHidden),
    );
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    final result = await _authRepository.login(email, password);

    result.handle(
      onSuccess: (String token) async {
        _analyticsService.logEvent(
          name: AnalyticsEventNames.loginSuccess,
          parameters: {'email': email},
        );
        _iapService.login(token);
        await _sessionRepository.setLoggedIn(true);
        await _sessionRepository.setToken(token);
        emit(state.copyWith(loginStatus: LoginStatus.success));
      },
      onError: (error) {
        _analyticsService.logEvent(
          name: AnalyticsEventNames.loginFailed,
          parameters: {'email': email},
        );
        emit(state.copyWith(loginStatus: LoginStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}
