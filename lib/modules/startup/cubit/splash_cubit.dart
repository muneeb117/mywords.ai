import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mywords/core/network/dio_client.dart';
import 'package:mywords/modules/authentication/repository/session_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SessionRepository _sessionRepository;
  final DioClient _dioClient;

  SplashCubit({required SessionRepository sessionRepository, required DioClient dioClient})
      : _sessionRepository = sessionRepository,
        _dioClient = dioClient,
        super(SplashInitial());

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 1800));

    final bool isNewUser = _sessionRepository.checkIfNewUser();
    final bool isUserLoggedIn = await _sessionRepository.isUserLoggedIn();
    final String token = _sessionRepository.getToken() ?? '';

    if (isNewUser) {
      emit(ShowOnboarding());
    } else if (isUserLoggedIn) {
      _dioClient.setToken(token);
      emit(ShowHome());
    } else {
      emit(ShowLogin());
    }
  }
}
