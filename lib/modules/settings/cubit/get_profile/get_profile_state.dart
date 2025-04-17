part of 'get_profile_cubit.dart';

enum GetProfileStatus {
  initial,
  loading,
  success,
  failed,
}

class GetProfileState {
  final GetProfileStatus getProfileStatus;
  final String errorMsg;

  GetProfileState({
    required this.errorMsg,
    required this.getProfileStatus,
  });

  factory GetProfileState.initial() {
    return GetProfileState(
      errorMsg: '',
      getProfileStatus: GetProfileStatus.initial,
    );
  }

  GetProfileState copyWith({
    String? errorMsg,
    GetProfileStatus? getProfileStatus,
  }) {
    return GetProfileState(
      errorMsg: errorMsg ?? this.errorMsg,
      getProfileStatus: getProfileStatus ?? this.getProfileStatus,
    );
  }
}
