import 'package:bloc/bloc.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final SessionRepository _sessionRepository;

  AccountCubit({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(AccountState.initial());

  void logout() async {
    emit(state.copyWith(accountStatus: AccountStatus.loading));
    await Future.delayed(Duration(seconds: 2));
    await _sessionRepository.clearSession();
    emit(state.copyWith(accountStatus: AccountStatus.success));
  }
}
