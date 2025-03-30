import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 1800));

    final bool isNewUser = await _checkIfNewUser();
    final bool isUserLoggedIn = await _checkUserAuthentication();

    if (isNewUser) {
      emit(ShowOnboarding());
    } else if (isUserLoggedIn) {
      emit(ShowHome());
    } else {
      emit(ShowLogin());
    }
  }

  Future<bool> _checkIfNewUser() async {
    return true;
  }

  Future<bool> _checkUserAuthentication() async {
    return false;
  }
}
