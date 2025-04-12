import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/startup/cubit/splash_cubit.dart';
import 'package:mywords/modules/startup/widgets/splash_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        sessionRepository: sl(),
        dioClient: sl(),
      )..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is ShowLogin) {
            Navigator.pushNamedAndRemoveUntil(context, RouteManager.login, (route) => false);
          } else if (state is ShowHome) {
            Navigator.pushNamedAndRemoveUntil(context, RouteManager.home, (route) => false);
          } else if (state is ShowOnboarding) {
            Navigator.pushNamedAndRemoveUntil(context, RouteManager.onboarding, (route) => false);
          }
        },
        child: SplashWidget(),
      ),
    );
  }
}
