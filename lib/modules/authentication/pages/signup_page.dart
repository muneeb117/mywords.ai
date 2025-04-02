import 'package:flutter/material.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/modules/authentication/widgets/auth_header_widget.dart';
import 'package:mywords/modules/authentication/widgets/google_auth_button.dart';
import 'package:mywords/modules/authentication/widgets/or_divider_widget.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeaderWidget(title: 'Join Us Today'),
            SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      hintText: 'Your full name',
                      prefixIconPath: 'assets/images/svg/ic_email.svg',
                      hasPrefixIcon: false,
                    ),
                    SizedBox(height: 12),
                    Text('Email', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      hintText: 'Email',
                      prefixIconPath: 'assets/images/svg/ic_email.svg',
                    ),
                    SizedBox(height: 12),
                    Text('Password', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      hintText: 'Password',
                      prefixIconPath: 'assets/images/svg/ic_lock.svg',
                    ),
                    SizedBox(height: 12),
                    Text('Confirm Password', style: context.textTheme.titleMedium),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      hintText: 'Confirm Password',
                      prefixIconPath: 'assets/images/svg/ic_lock.svg',
                    ),
                    SizedBox(height: 16),
                    PrimaryButton.gradient(
                      title: 'Sign Up',
                      onTap: () {
                        // todo :: Implement sign-up
                        Navigator.pushNamedAndRemoveUntil(context, RouteManager.home, (route) => false);
                      },
                      fontWeight: FontWeight.bold,
                    ),
                    OrDividerWidget(),
                    GoogleAuthButton(onTap: () {
                      // todo :: Implement google auth
                    }),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, RouteManager.login);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8, bottom: 8),
                            child: Text(
                              'Login',
                              style: context.textTheme.titleMedium
                                  ?.copyWith(color: context.colorScheme.secondary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
