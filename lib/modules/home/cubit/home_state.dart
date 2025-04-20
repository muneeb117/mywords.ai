part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failed }

class HomeState {
  final HomeStatus homeStatus;
  final String errorMsg;
  final int hoursSaved;

  HomeState({
    required this.homeStatus,
    required this.errorMsg,
    required this.hoursSaved,
  });

  factory HomeState.initial() {
    return HomeState(
      homeStatus: HomeStatus.initial,
      hoursSaved: 0,
      errorMsg: '',
    );
  }

  HomeState copyWith({
    HomeStatus? homeStatus,
    int? hoursSaved,
    String? errorMsg,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      hoursSaved: hoursSaved ?? this.hoursSaved,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
