import 'package:bloc/bloc.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final SessionRepository _sessionRepository;

  LogoutCubit({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(LogoutState.initial());

  void logout() async {
    emit(state.copyWith(logoutStatus: LogoutStatus.loading));
    await Future.delayed(Duration(seconds: 2));
    await _sessionRepository.clearSession();
    emit(state.copyWith(logoutStatus: LogoutStatus.success));
  }
}
