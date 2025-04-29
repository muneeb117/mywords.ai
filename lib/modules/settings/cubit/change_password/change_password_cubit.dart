import 'package:bloc/bloc.dart';
import 'package:mywords/modules/settings/repository/settings_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final SettingsRepository _settingsRepository;

  ChangePasswordCubit({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(ChangePasswordState.initial());

  void toggleCurrentPassword() {
    emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.initial, isCurrentPasswordHidden: !state.isCurrentPasswordHidden));
  }

  void toggleNewPasswordPassword() {
    emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.initial, isNewPasswordHidden: !state.isNewPasswordHidden));
  }

  void toggleConfirmNewPasswordPassword() {
    emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.initial, isConfirmNewPasswordHidden: !state.isConfirmNewPasswordHidden));
  }

  void changePassword(String password, String newPassword) async {
    emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.loading));

    final result = await _settingsRepository.changePassword(password, newPassword);

    result.handle(
      onSuccess: (result) async {
        emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.failure, errorMsg: error.errorMsg));
      },
    );
  }
}
