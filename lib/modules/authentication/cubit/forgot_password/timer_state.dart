part of 'timer_cubit.dart';

@immutable
sealed class TimerState {}

final class TimerInitial extends TimerState {}

final class TimerInProgress extends TimerState {
  final int secondsRemaining;

  TimerInProgress(this.secondsRemaining);
}

final class TimerCompleted extends TimerState {}