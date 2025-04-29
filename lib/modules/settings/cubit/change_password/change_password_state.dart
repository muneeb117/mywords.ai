part of 'change_password_cubit.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState {
  final ChangePasswordStatus changePasswordStatus;
  final bool isCurrentPasswordHidden;
  final bool isNewPasswordHidden;
  final bool isConfirmNewPasswordHidden;
  final String errorMsg;

  ChangePasswordState({
    required this.errorMsg,
    required this.changePasswordStatus,
    required this.isCurrentPasswordHidden,
    required this.isNewPasswordHidden,
    required this.isConfirmNewPasswordHidden,
  });

  factory ChangePasswordState.initial() {
    return ChangePasswordState(
      isCurrentPasswordHidden: true,
      isNewPasswordHidden: true,
      isConfirmNewPasswordHidden: true,
      errorMsg: '',
      changePasswordStatus: ChangePasswordStatus.initial,
    );
  }

  ChangePasswordState copyWith({
    String? errorMsg,
    ChangePasswordStatus? changePasswordStatus,
    bool? isCurrentPasswordHidden,
    bool? isNewPasswordHidden,
    bool? isConfirmNewPasswordHidden,
  }) {
    return ChangePasswordState(
      errorMsg: errorMsg ?? this.errorMsg,
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      isCurrentPasswordHidden: isCurrentPasswordHidden ?? this.isCurrentPasswordHidden,
      isNewPasswordHidden: isNewPasswordHidden ?? this.isNewPasswordHidden,
      isConfirmNewPasswordHidden: isConfirmNewPasswordHidden ?? this.isConfirmNewPasswordHidden,
    );
  }
}
