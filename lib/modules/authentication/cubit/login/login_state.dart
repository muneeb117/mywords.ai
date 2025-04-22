part of 'login_cubit.dart';

enum LoginStatus { initial, loading, googleLoading, googleSuccess, success, failed }

class LoginState {
  final bool isPasswordHidden;
  final String name;
  final String email;
  final String errorMsg;
  final LoginStatus loginStatus;

  LoginState({
    required this.isPasswordHidden,
    required this.name,
    required this.email,
    required this.errorMsg,
    required this.loginStatus,
  });

  factory LoginState.initial() {
    return LoginState(
      isPasswordHidden: true,
      name: '',
      email: '',
      errorMsg: '',
      loginStatus: LoginStatus.initial,
    );
  }

  LoginState copyWith({
    bool? isPasswordHidden,
    String? name,
    String? email,
    String? errorMsg,
    LoginStatus? loginStatus,
  }) {
    return LoginState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      name: name ?? this.email,
      email: email ?? this.email,
      errorMsg: errorMsg ?? this.errorMsg,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}
