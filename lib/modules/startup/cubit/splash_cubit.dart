import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final isAuthenticated = await _checkUserAuthentication();
    emit(isAuthenticated ? Authenticated() : Unauthenticated());
  }

  Future<bool> _checkUserAuthentication() async {
    return true;
  }
}