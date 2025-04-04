part of 'signup_cubit.dart';

class SignupState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final String password;
  final String confirmPassword;

  SignupState({
    required this.isPasswordHidden,
    required this.isConfirmPasswordHidden,
    required this.password,
    required this.confirmPassword,
  });

  factory SignupState.initial() {
    return SignupState(
      isPasswordHidden: true,
      isConfirmPasswordHidden: true,
      password: '',
      confirmPassword: '',
    );
  }

  SignupState copyWith({
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    String? password,
    String? confirmPassword,
  }) {
    return SignupState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden: isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
