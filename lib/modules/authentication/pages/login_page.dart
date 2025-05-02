import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/loading_indicator.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/authentication/cubit/login/login_cubit.dart';
import 'package:mywords/modules/authentication/cubit/signup/signup_cubit.dart';
import 'package:mywords/modules/authentication/cubit/social_auth/social_auth_cubit.dart';
import 'package:mywords/modules/authentication/widgets/auth_header_widget.dart';
import 'package:mywords/modules/authentication/widgets/google_auth_button.dart';
import 'package:mywords/modules/authentication/widgets/or_divider_widget.dart';
import 'package:mywords/modules/authentication/widgets/remember_me_and_forgot_pwd_widget.dart';
import 'package:mywords/utils/extensions/email_validator.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _analyticsService = sl<AnalyticsService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => LoginCubit(
                authRepository: sl(),
                sessionRepository: sl(),
                socialAuthRepository: sl(),
                analyticsService: sl(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SignupCubit(
                authRepository: sl(),
                sessionRepository: sl(),
                analyticsService: sl(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SocialAuthCubit(
                authRepository: sl(),
                socialAuthRepository: sl(),
                sessionRepository: sl(),
                analyticsService: sl(),
              ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final socialAuthState = context.watch<SocialAuthCubit>().state;
          final signupState = context.watch<SignupCubit>().state;

          bool isSigningUpWithGoogle =
              socialAuthState.socialAuthStatus == SocialAuthStatus.loading ||
              signupState.signupStatus == SignupStatus.loading;
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  title: Padding(
                    padding: EdgeInsets.only(top: 10.ch),
                    child: TopAppIconAndTitleWidget(),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.all(16.ch),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontSize: 24.ch,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 14.ch),
                          Text('Email', style: context.textTheme.titleMedium),
                          SizedBox(height: 8.ch),
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
                          SizedBox(height: 12.ch),
                          Text('Password', style: context.textTheme.titleMedium),
                          SizedBox(height: 8.ch),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              return InputField.password(
                                hintText: 'Password',
                                controller: passwordController,
                                suffixIconPath:
                                    state.isPasswordHidden
                                        ? 'assets/images/svg/ic_pwd_hidden.svg'
                                        : 'assets/images/svg/ic_pwd_shown.svg',
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
                          SizedBox(height: 8.ch),
                          RememberMeAndForgotPasswordTile(
                            onRememberMeTap: () {},
                            onForgotPasswordTap: () {
                              _analyticsService.logEvent(
                                name: AnalyticsEventNames.forgotPasswordInitiated,
                              );
                              Navigator.pushNamed(context, RouteManager.forgotPasswordEmail);
                            },
                          ),
                          SizedBox(height: 8.ch),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state.loginStatus == LoginStatus.success) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteManager.home,
                                  (route) => false,
                                );
                              } else if (state.loginStatus == LoginStatus.failed) {
                                context.showSnackBar(state.errorMsg);
                              }
                            },
                            builder: (context, state) {
                              return BlocListener<SignupCubit, SignupState>(
                                listener: (context, signupState) {
                                  if (signupState.signupStatus == SignupStatus.success) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteManager.home,
                                      (route) => false,
                                    );
                                  } else if (signupState.signupStatus == LoginStatus.failed) {
                                    context.showSnackBar(signupState.errorMsg);
                                  }
                                },
                                child: PrimaryButton.gradient(
                                  title: 'Sign in',
                                  isLoading: state.loginStatus == LoginStatus.loading,
                                  onTap: () {
                                    // If left side evaluates to null, and null == true is false
                                    bool isFormValidated =
                                        _formKey.currentState?.validate() == true;
                                    if (isFormValidated) {
                                      context.closeKeyboard();
                                      final email = emailController.text.toLowerCase().trim();
                                      final password = passwordController.text.trim();
                                      context.read<LoginCubit>().login(email, password);
                                    }
                                  },
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          OrDividerWidget(),
                          SocialAuthButton(
                            platform: 'Google',
                            iconPath: 'assets/images/svg/ic_google.svg',
                            onTap: () {
                              context.read<SocialAuthCubit>().loginWithGoogle();
                            },
                          ),
                          BlocListener<SocialAuthCubit, SocialAuthState>(
                            listener: (context, state) {
                              if (state.socialAuthStatus == SocialAuthStatus.success) {
                                /// Signup with google
                                context.read<SignupCubit>().signup(
                                  state.name,
                                  state.email,
                                  '', // password
                                  provider: state.provider,
                                );
                              } else if (state.socialAuthStatus == SocialAuthStatus.failed) {
                                if (!state.errorMsg.contains('cancelled by user')) {
                                  context.showSnackBar(state.errorMsg);
                                }
                              }
                            },
                            child: SizedBox(height: 12.ch),
                          ),
                          SocialAuthButton(
                            platform: 'Apple',
                            iconPath: 'assets/images/svg/ic_apple.svg',
                            onTap: () {
                              context.read<SocialAuthCubit>().loginWithApple();
                            },
                          ),
                          SizedBox(height: 8.ch),
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
                                  _analyticsService.logEvent(
                                    name: AnalyticsEventNames.signupInitiated,
                                  );
                                  Navigator.pushReplacementNamed(context, RouteManager.signup);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 4.ch,
                                    right: 4.ch,
                                    top: 8.ch,
                                    bottom: 8.ch,
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: context.textTheme.titleMedium?.copyWith(
                                      color: context.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isSigningUpWithGoogle)
                Container(
                  color: Colors.black.withOpacity(0.15),
                  child: LoadingIndicator(bgColor: AppColors.black),
                ),
            ],
          );
        },
      ),
    );
  }
}
