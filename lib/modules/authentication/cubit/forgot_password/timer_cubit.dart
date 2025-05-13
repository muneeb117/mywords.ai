import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;

  TimerCubit() : super(TimerInitial());

  void startTimer() {
    int seconds = 10;
    emit(TimerInProgress(seconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds > 0) {
        emit(TimerInProgress(seconds));
      } else {
        timer.cancel();
        emit(TimerCompleted());
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
