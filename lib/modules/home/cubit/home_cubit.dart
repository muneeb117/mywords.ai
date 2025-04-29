import 'package:bloc/bloc.dart';
import 'package:mywords/modules/home/repository/home_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit({required HomeRepository homeRepository}) : _homeRepository = homeRepository, super(HomeState.initial());

  void fetchDocumentHours() async {
    // emit(state.copyWith(homeStatus: HomeStatus.loading));

    final result = await _homeRepository.getDocumentsCount();
    // await Future.delayed(Duration(milliseconds: 1500));
    // final result = Right<ApiError, int>(6);

    result.handle(
      onSuccess: (int documentCount) {
        int avgTimeSavedPerDoc = 20;
        final hoursSaved = (documentCount * avgTimeSavedPerDoc) / 60;
        final roundedHours = hoursSaved.floor();

        emit(state.copyWith(homeStatus: HomeStatus.success, hoursSaved: roundedHours));
      },
      onError: (error) {
        emit(state.copyWith(homeStatus: HomeStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}
