import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/authentication/cubit/login/login_cubit.dart';
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authRepository: sl(), sessionRepository: sl()),
      child: Builder(
        builder: (context) {
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
                      InputField.email(
                        hintText: 'Email',
                        controller: emailController,
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
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return InputField.password(
                            hintText: 'Password',
                            controller: passwordController,
                            suffixIconPath:
                                state.isPasswordHidden ? 'assets/images/svg/ic_pwd_hidden.svg' : 'assets/images/svg/ic_pwd_shown.svg',
                            obscureText: state.isPasswordHidden,
                            onSuffixIconTap: () {
                              context.read<LoginCubit>().togglePassword();
                            },
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      RememberMeAndForgotPasswordTile(
                        onRememberMeTap: () {},
                        onForgotPasswordTap: () {
                          Navigator.pushNamed(context, RouteManager.forgotPasswordEmail);
                        },
                      ),
                      SizedBox(height: 8),
                      BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state.loginStatus == LoginStatus.success) {
                            Navigator.pushNamedAndRemoveUntil(context, RouteManager.home, (route) => false);
                          } else if (state.loginStatus == LoginStatus.failed) {
                            context.showSnackBar(state.errorMsg);
                          }
                        },
                        builder: (context, state) {
                          return PrimaryButton.gradient(
                            title: 'Sign in',
                            isLoading: state.loginStatus == LoginStatus.loading,
                            onTap: () {
                              // If left side evaluates to null, and null == true is false
                              bool isFormValidated = _formKey.currentState?.validate() == true;
                              if (isFormValidated) {
                                context.closeKeyboard();
                                final email = emailController.text.toLowerCase().trim();
                                final password = passwordController.text.trim();
                                context.read<LoginCubit>().login(email, password);
                              }
                            },
                            fontWeight: FontWeight.bold,
                          );
                        },
                      ),
                      OrDividerWidget(),
                      // if(kDebugMode)AutoLoginButton(onTap: () {
                      //   final email = 'shams@yopmail.com';
                      //   final password = 'Password@123';
                      //   context.read<LoginCubit>().login(email, password);
                      // }),
                      // SizedBox(height: 8),
                      GoogleAuthButton(onTap: () {}),
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
        },
      ),
    );
  }
}
