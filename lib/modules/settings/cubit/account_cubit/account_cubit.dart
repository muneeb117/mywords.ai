import 'package:bloc/bloc.dart';
import 'package:mywords/core/network/dio_client.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';
import 'package:mywords/modules/authentication/repository/social_auth_repository.dart';
import 'package:mywords/modules/settings/repository/settings_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final SessionRepository _sessionRepository;
  final SettingsRepository _settingsRepository;
  final SocialAuthRepository _socialAuthRepository;
  final DioClient _dioClient;

  AccountCubit({
    required SessionRepository sessionRepository,
    required SettingsRepository settingsRepository,
    required SocialAuthRepository socialAuthRepository,
    required DioClient dioClient,
  })  : _sessionRepository = sessionRepository,
        _settingsRepository = settingsRepository,
        _socialAuthRepository = socialAuthRepository,
        _dioClient = dioClient,
        super(AccountState.initial());

  void logout() async {
    emit(state.copyWith(accountStatus: AccountStatus.loggingOut));
    await Future.delayed(Duration(seconds: 2));
    _dioClient.clearToken();
    await _sessionRepository.clearSession();
    await _socialAuthRepository.signOut();
    emit(state.copyWith(accountStatus: AccountStatus.logoutSuccess));
  }

  void deleteAccount() async {
    emit(state.copyWith(accountStatus: AccountStatus.deleting));
    final result = await _settingsRepository.deleteAccount();

    result.handle(
      onSuccess: (result) async {
        _dioClient.clearToken();
        await _sessionRepository.clearSession();
        await _socialAuthRepository.signOut();
        emit(state.copyWith(accountStatus: AccountStatus.deleteSuccess));
      },
      onError: (error) {
        emit(state.copyWith(accountStatus: AccountStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}
