import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/modules/startup/cubit/splash_cubit.dart';
import 'package:mywords/modules/startup/widgets/splash_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is ShowLogin) {
            Navigator.pushReplacementNamed(context, RouteManager.login);
          } else if (state is ShowHome) {
            Navigator.pushReplacementNamed(context, RouteManager.home);
          } else if (state is ShowOnboarding) {
            Navigator.pushReplacementNamed(context, RouteManager.onboarding);
          }
        },
        child: SplashWidget(),
      ),
    );
  }
}
