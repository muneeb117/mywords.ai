part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class ShowOnboarding extends SplashState {}

final class ShowLogin extends SplashState {}

final class ShowHome extends SplashState {}
