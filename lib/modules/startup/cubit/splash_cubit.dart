import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SessionRepository _sessionRepository;

  SplashCubit({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(SplashInitial());

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 1800));

    final bool isNewUser = _sessionRepository.checkIfNewUser();
    final bool isUserLoggedIn = await _sessionRepository.isUserLoggedIn();

    if (isNewUser) {
      emit(ShowOnboarding());
    } else if (isUserLoggedIn) {
      emit(ShowHome());
    } else {
      emit(ShowLogin());
    }
  }
}