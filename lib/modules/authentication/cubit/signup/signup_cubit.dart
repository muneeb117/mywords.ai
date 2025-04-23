import 'package:bloc/bloc.dart';
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

  SignupCubit({
    required AuthRepository authRepository,
    required SocialAuthRepository socialAuthRepository,
    required SessionRepository sessionRepository,
  })  : _authRepository = authRepository,
        _socialAuthRepository = socialAuthRepository,
        _sessionRepository = sessionRepository,
        super(SignupState.initial());

  void togglePassword() {
    emit(state.copyWith(
      signupStatus: SignupStatus.initial,
      isPasswordHidden: !state.isPasswordHidden,
    ));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(
      signupStatus: SignupStatus.initial,
      isConfirmPasswordHidden: !state.isConfirmPasswordHidden,
    ));
  }

  Future<void> signup(String fullName, String email, String password, {String provider = ''}) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading, isGoogleLoading: provider == 'google'));
    final result = await _authRepository.signup(fullName, email, password, provider);

    result.handle(
      onSuccess: (String token) async {
        if (state.isGoogleLoading) {
          await _sessionRepository.setLoggedIn(true);
          await _sessionRepository.setToken(token);
        }
        emit(state.copyWith(signupStatus: SignupStatus.success, isGoogleLoading: false));
      },
      onError: (error) {
        print('error is :: $error');
        emit(state.copyWith(signupStatus: SignupStatus.failed, errorMsg: error.errorMsg, isGoogleLoading: false));
      },
    );
  }

  Future<void> signupWithGoogle() async {
    emit(state.copyWith(signupStatus: SignupStatus.googleLoading));
    try {
      final result = await _socialAuthRepository.loginWithGoogle();
      if (result.email.isNotEmpty && result.name.isNotEmpty) {
        emit(
          state.copyWith(
            signupStatus: SignupStatus.googleSuccess,
            name: result.name,
            email: result.email,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMsg: 'Some error occurs, Please try again',
            signupStatus: SignupStatus.failed,
          ),
        );
      }
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMsg: e.message,
          signupStatus: SignupStatus.failed,
        ),
      );
    } catch (_) {
      emit(state.copyWith(signupStatus: SignupStatus.failed));
    }
  }
}
