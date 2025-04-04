import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/storage/storage_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final StorageService storageService;

  SplashCubit({required this.storageService}) : super(SplashInitial());


  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 1800));

    final bool isNewUser = _checkIfNewUser();
    final bool isUserLoggedIn = await _checkUserAuthentication();

    if (isNewUser) {
      emit(ShowOnboarding());
    } else if (isUserLoggedIn) {
      emit(ShowHome());
    } else {
      emit(ShowLogin());
    }
  }

  bool _checkIfNewUser() {
    return storageService.getBool(AppKeys.isNewUser) ?? true;
  }

  Future<bool> _checkUserAuthentication() async {
    // todo :: Implement the core auth logic
    return false;
  }
}
