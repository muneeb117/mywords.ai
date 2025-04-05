part of 'logout_cubit.dart';

enum LogoutStatus { initial, loading, success, failed }

class LogoutState {
  final LogoutStatus logoutStatus;
  final String errorMsg;

  LogoutState({
    required this.errorMsg,
    required this.logoutStatus,
  });

  factory LogoutState.initial() {
    return LogoutState(
      errorMsg: '',
      logoutStatus: LogoutStatus.initial,
    );
  }

  LogoutState copyWith({
    String? errorMsg,
    LogoutStatus? logoutStatus,
  }) {
    return LogoutState(
      errorMsg: errorMsg ?? this.errorMsg,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }
}
