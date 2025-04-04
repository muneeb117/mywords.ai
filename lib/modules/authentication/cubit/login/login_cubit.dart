import 'package:bloc/bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  void togglePassword() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }
}
