import 'package:bloc/bloc.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;

  LoginCubit({required AuthRepository authRepository, required SessionRepository sessionRepository})
      : _authRepository = authRepository,
        _sessionRepository = sessionRepository,
        super(LoginState.initial());

  void togglePassword() {
    emit(state.copyWith(
      loginStatus: LoginStatus.initial,
      isPasswordHidden: !state.isPasswordHidden,
    ));
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    final result = await _authRepository.login(email, password);

    result.handle(
      onSuccess: (String token) async {
        await _sessionRepository.setLoggedIn(true);
        await _sessionRepository.setToken(token);
        emit(state.copyWith(loginStatus: LoginStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(loginStatus: LoginStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}
