part of 'social_auth_cubit.dart';

enum SocialAuthStatus { initial, loading, success, failed }

class SocialAuthState {
  final String name;
  final String email;
  final String errorMsg;
  final SocialAuthStatus socialAuthStatus;

  SocialAuthState({
    required this.name,
    required this.email,
    required this.errorMsg,
    required this.socialAuthStatus,
  });

  factory SocialAuthState.initial() {
    return SocialAuthState(
      name: '',
      email: '',
      errorMsg: '',
      socialAuthStatus: SocialAuthStatus.initial,
    );
  }

  SocialAuthState copyWith({
    String? name,
    String? email,
    String? errorMsg,
    SocialAuthStatus? socialAuthStatus,
  }) {
    return SocialAuthState(
      name: name ?? this.email,
      email: email ?? this.email,
      errorMsg: errorMsg ?? this.errorMsg,
      socialAuthStatus: socialAuthStatus ?? this.socialAuthStatus,
    );
  }
}
