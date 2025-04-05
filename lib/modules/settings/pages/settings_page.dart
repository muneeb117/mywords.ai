import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/settings/cubit/logout_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(sessionRepository: sl()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'Settings',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: BlocConsumer<LogoutCubit, LogoutState>(
                      listener: (context, state) {
                        if (state.logoutStatus == LogoutStatus.success) {
                          Navigator.pushNamedAndRemoveUntil(context, RouteManager.login, (route) => false);
                        } else if (state.logoutStatus == LogoutStatus.failed) {
                          context.showSnackBar(state.errorMsg);
                        }
                      },
                      builder: (context, state) {
                        return PrimaryButton.filled(
                          backgroundColor: AppColors.darkOrangeBg,
                          textColor: AppColors.darkOrange,
                          indicatorColor: AppColors.darkOrange,
                          fontWeight: FontWeight.w700,
                          enableShrinkAnimation: true,
                          isLoading: state.logoutStatus == LogoutStatus.loading,
                          iconPath: 'assets/images/svg/ic_logout.svg',
                          onTap: () {
                            context.read<LogoutCubit>().logout();
                          },
                          title: 'Logout',
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
