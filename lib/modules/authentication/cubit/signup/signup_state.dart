part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, googleLoading, googleSuccess, success, failed }

class SignupState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final SignupStatus signupStatus;
  final String name;
  final String email;
  final String errorMsg;
  final bool isGoogleLoading;

  SignupState({
    required this.isPasswordHidden,
    required this.isConfirmPasswordHidden,
    required this.signupStatus,
    required this.name,
    required this.email,
    required this.errorMsg,
    required this.isGoogleLoading,
  });

  factory SignupState.initial() {
    return SignupState(
      isPasswordHidden: true,
      isConfirmPasswordHidden: true,
      isGoogleLoading: false,
      signupStatus: SignupStatus.initial,
      name: '',
      email: '',
      errorMsg: '',
    );
  }

  SignupState copyWith({
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    bool? isGoogleLoading,
    SignupStatus? signupStatus,
    String? name,
    String? email,
    String? errorMsg,
  }) {
    return SignupState(
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden: isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      signupStatus: signupStatus ?? this.signupStatus,
      name: name ?? this.name,
      email: email ?? this.email,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
