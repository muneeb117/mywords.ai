part of 'account_cubit.dart';

enum AccountStatus { initial, deleting, loggingOut, deleteSuccess, logoutSuccess, failed }

class AccountState {
  final AccountStatus accountStatus;
  final String errorMsg;

  AccountState({required this.errorMsg, required this.accountStatus});

  factory AccountState.initial() {
    return AccountState(errorMsg: '', accountStatus: AccountStatus.initial);
  }

  AccountState copyWith({String? errorMsg, AccountStatus? accountStatus}) {
    return AccountState(errorMsg: errorMsg ?? this.errorMsg, accountStatus: accountStatus ?? this.accountStatus);
  }
}
