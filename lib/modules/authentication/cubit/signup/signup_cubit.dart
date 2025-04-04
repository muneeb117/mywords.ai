import 'package:bloc/bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState.initial());

  void togglePassword() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(isConfirmPasswordHidden: !state.isConfirmPasswordHidden));
  }

  void updatePassword(String value) {
    state.copyWith(password: value);
  }

  void updateConfirmPassword(String value) {
    state.copyWith(confirmPassword: value);
  }
}
