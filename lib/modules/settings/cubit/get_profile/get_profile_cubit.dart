import 'package:bloc/bloc.dart';
import 'package:mywords/modules/settings/repository/settings_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  final SettingsRepository _settingsRepository;

  GetProfileCubit({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(GetProfileState.initial());

  void getProfile() async {
    emit(state.copyWith(getProfileStatus: GetProfileStatus.loading));
    final result = await _settingsRepository.getProfile();

    result.handle(
      onSuccess: (result) async {
        emit(state.copyWith(getProfileStatus: GetProfileStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(getProfileStatus: GetProfileStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}
