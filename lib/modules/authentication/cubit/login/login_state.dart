part of 'login_cubit.dart';

class LoginState {
  final bool isPasswordHidden;

  LoginState({
    required this.isPasswordHidden,
  });

  factory LoginState.initial() {
    return LoginState(isPasswordHidden: true);
  }

  LoginState copyWith({
    bool? isPasswordHidden,
  }) {
    return LoginState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    );
  }
}
