import 'package:flutter/material.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/authentication/widgets/auth_header_widget.dart';
import 'package:mywords/modules/authentication/widgets/google_auth_button.dart';
import 'package:mywords/modules/authentication/widgets/or_divider_widget.dart';
import 'package:mywords/modules/authentication/widgets/remember_me_and_forgot_pwd_widget.dart';
import 'package:mywords/utils/extensions/email_validator.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TopAppIconAndTitleWidget(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // AuthHeaderWidget(title: 'Login'),
                SizedBox(height: 16),
                Text('Email', style: context.textTheme.titleMedium),
                SizedBox(height: 8),
                CustomTextFormField(
                  hintText: 'Email',
                  prefixIconPath: 'assets/images/svg/ic_email.svg',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    } else if (!value.isValidEmail) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Text('Password', style: context.textTheme.titleMedium),
                SizedBox(height: 8),
                CustomTextFormField(
                  hintText: 'Password',
                  prefixIconPath: 'assets/images/svg/ic_lock.svg',
                  keyboardType: TextInputType.visiblePassword,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                RememberMeAndForgotPasswordTile(
                  onRememberMeTap: () {},
                  onForgotPasswordTap: () {},
                ),
                SizedBox(height: 8),

                PrimaryButton.gradient(
                  title: 'Sign in',
                  onTap: () {
                    // If left side evaluates to null, and null == true is false
                    bool isFormValidated = _formKey.currentState?.validate() == true;
                    if (isFormValidated) {}
                    // todo :: Implement sign-in
                    // Navigator.pushNamed(context, RouteManager.home);
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
                      "Don't have an account?",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, RouteManager.signup);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8, bottom: 8),
                        child: Text(
                          'Sign Up',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
