import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/settings/cubit/logout_cubit.dart';
import 'package:mywords/modules/settings/widgets/settings_tile.dart';
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
            appBar: CustomAppBar(title: 'Settings'),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsTile(
                    onTap: () {
                      Navigator.pushNamed(context, RouteManager.accountSettings);
                    },
                    title: 'Account Settings',
                    assetPath: 'assets/images/svg/ic_settings.svg',
                  ),
                  Divider(height: 0, color: Color(0xffEEEEEE)),
                  SettingsTile(
                    onTap: () {},
                    title: 'Billing',
                    assetPath: 'assets/images/svg/ic_billing.svg',
                  ),
                  Divider(height: 0, color: Color(0xffEEEEEE)),
                  SettingsTile(
                    onTap: () {},
                    title: 'Privacy Policy',
                    assetPath: 'assets/images/svg/ic_privacy_policy.svg',
                  ),
                  Divider(height: 0, color: Color(0xffEEEEEE)),
                  SettingsTile(
                    onTap: () {
                      Navigator.pushNamed(context, RouteManager.passwordSecurity);
                    },
                    title: 'Passwords Security',
                    assetPath: 'assets/images/svg/ic_password_security.svg',
                  ),
                  Divider(height: 0, color: Color(0xffEEEEEE)),
                  SettingsTile(
                    onTap: () {},
                    title: 'Delete Account',
                    assetPath: 'assets/images/svg/ic_delete_acc.svg',
                    textColor: Color(0xffFF3D00),
                  ),
                  Divider(height: 0, color: Color(0xffEEEEEE)),
                  SizedBox(height: 24),
                  BlocConsumer<LogoutCubit, LogoutState>(
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
                        indicatorColor: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        enableShrinkAnimation: false,
                        isLoading: state.logoutStatus == LogoutStatus.loading,
                        iconPath: 'assets/images/svg/ic_logout.svg',
                        onTap: () {
                          context.read<LogoutCubit>().logout();
                        },
                        title: 'Logout',
                      );
                    },
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
