part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, success, failed }

class SignupState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final SignupStatus signupStatus;
  final String errorMsg;

  SignupState({
    required this.isPasswordHidden,
    required this.isConfirmPasswordHidden,
    required this.signupStatus,
    required this.errorMsg,
  });

  factory SignupState.initial() {
    return SignupState(
      isPasswordHidden: true,
      isConfirmPasswordHidden: true,
      signupStatus: SignupStatus.initial,
      errorMsg: '',
    );
  }

  SignupState copyWith({
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    SignupStatus? signupStatus,
    String? errorMsg,
  }) {
    return SignupState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden: isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      signupStatus: signupStatus ?? this.signupStatus,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
