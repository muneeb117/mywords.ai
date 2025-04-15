part of 'forgot_password_cubit.dart';

enum ForgotPasswordStep {
  emailInput,
  otpInput,
  newPassword,

}

enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

class ForgotPasswordState {
  final String email;
  final String otp;
  final String newPassword;
  final ForgotPasswordStep step;
  final ForgotPasswordStatus status;
  final String errorMessage;

  const ForgotPasswordState({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.step,
    required this.status,
    required this.errorMessage,
  });

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      otp: '',
      newPassword: '',
      step: ForgotPasswordStep.emailInput,
      status: ForgotPasswordStatus.initial,
      errorMessage: '',
    );
  }

  ForgotPasswordState copyWith({
    String? email,
    String? otp,
    String? newPassword,
    ForgotPasswordStep? step,
    ForgotPasswordStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
