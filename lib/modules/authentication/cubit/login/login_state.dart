part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failed }

class LoginState {
  final bool isPasswordHidden;
  final String errorMsg;
  final LoginStatus loginStatus;

  LoginState({
    required this.isPasswordHidden,
    required this.errorMsg,
    required this.loginStatus,
  });

  factory LoginState.initial() {
    return LoginState(
      isPasswordHidden: true,
      errorMsg: '',
      loginStatus: LoginStatus.initial,
    );
  }

  LoginState copyWith({
    bool? isPasswordHidden,
    String? errorMsg,
    LoginStatus? loginStatus,
  }) {
    return LoginState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      errorMsg: errorMsg ?? this.errorMsg,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}
