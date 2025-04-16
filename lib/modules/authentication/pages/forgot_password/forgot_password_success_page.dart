import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class ForgotPasswordSuccessPage extends StatelessWidget {
  const ForgotPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Confirmation', showLeading: false),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/svg/ic_confirmation.svg'),
              SizedBox(height: 20),
              Text(
                "You're All Set!",
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Your password has been successfully\nupdated.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.onSurface.withOpacity(0.9), height: 1),
              ),
              SizedBox(height: 150),
              PrimaryButton.filled(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, RouteManager.login, (route) => false);
                },
                title: 'Go to Log In',
                fontWeight: FontWeight.w700,
              )
            ],
          ),
        ),
      ),
    );
  }
}
