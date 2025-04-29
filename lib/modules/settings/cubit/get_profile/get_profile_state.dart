part of 'get_profile_cubit.dart';

enum GetProfileStatus { initial, loading, success, failed }

class GetProfileState {
  final GetProfileStatus getProfileStatus;
  final String errorMsg;
  final String fullName;
  final String email;

  GetProfileState({required this.errorMsg, required this.getProfileStatus, required this.fullName, required this.email});

  factory GetProfileState.initial() {
    return GetProfileState(errorMsg: '', getProfileStatus: GetProfileStatus.initial, fullName: '', email: '');
  }

  GetProfileState copyWith({String? errorMsg, GetProfileStatus? getProfileStatus, String? fullName, String? email}) {
    return GetProfileState(
      errorMsg: errorMsg ?? this.errorMsg,
      getProfileStatus: getProfileStatus ?? this.getProfileStatus,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}
