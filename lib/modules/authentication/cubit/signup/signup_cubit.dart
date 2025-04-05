import 'package:bloc/bloc.dart';
import 'package:mywords/modules/authentication/repository/auth_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void togglePassword() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(isConfirmPasswordHidden: !state.isConfirmPasswordHidden));
  }

  Future<void> signup(String fullName, String email, String password) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));
    final result = await _authRepository.signup(fullName, email, password);

    result.handle(
      onSuccess: (userId) {
        emit(state.copyWith(signupStatus: SignupStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(signupStatus: SignupStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}