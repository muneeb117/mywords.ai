import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/loading_indicator.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/authentication/cubit/login/login_cubit.dart';
import 'package:mywords/modules/authentication/cubit/signup/signup_cubit.dart';
import 'package:mywords/modules/authentication/cubit/social_auth/social_auth_cubit.dart'
    show SocialAuthCubit, SocialAuthState, SocialAuthStatus;
import 'package:mywords/modules/authentication/widgets/auth_header_widget.dart';
import 'package:mywords/modules/authentication/widgets/google_auth_button.dart';
import 'package:mywords/modules/authentication/widgets/or_divider_widget.dart';
import 'package:mywords/utils/extensions/email_validator.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
              (context) => LoginCubit(
                authRepository: sl(),
                sessionRepository: sl(),
                socialAuthRepository: sl(),
                analyticsService: sl(),
              ),
        ),
        BlocProvider(
          create:
              (context) => SocialAuthCubit(
                authRepository: sl(),
                sessionRepository: sl(),
                socialAuthRepository: sl(),
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
              signupState.isGoogleLoading;
          return Stack(
            children: [
              Scaffold(
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
                  padding: EdgeInsets.all(16.cw),
                  child: SingleChildScrollView(
                    child: BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Join Us Today',
                                style: context.textTheme.headlineMedium?.copyWith(
                                  fontSize: 24.csp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 16.ch),
                              Text('Full Name', style: context.textTheme.titleMedium),
                              SizedBox(height: 8.ch),
                              InputField(
                                hintText: 'Your full name',
                                prefixIconPath: 'assets/images/svg/ic_email.svg',
                                hasPrefixIcon: false,
                                controller: fullNameController,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12.ch),
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
                              InputField.password(
                                hintText: 'Password',
                                controller: passwordTextController,
                                suffixIconPath:
                                    state.isPasswordHidden
                                        ? 'assets/images/svg/ic_pwd_hidden.svg'
                                        : 'assets/images/svg/ic_pwd_shown.svg',
                                obscureText: state.isPasswordHidden,
                                onSuffixIconTap: () {
                                  context.read<SignupCubit>().togglePassword();
                                },
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 12.ch),
                              Text('Confirm Password', style: context.textTheme.titleMedium),
                              SizedBox(height: 8.ch),
                              InputField.password(
                                hintText: 'Confirm Password',
                                controller: confirmPasswordTextController,
                                suffixIconPath:
                                    state.isConfirmPasswordHidden
                                        ? 'assets/images/svg/ic_pwd_hidden.svg'
                                        : 'assets/images/svg/ic_pwd_shown.svg',
                                obscureText: state.isConfirmPasswordHidden,
                                onSuffixIconTap: () {
                                  context.read<SignupCubit>().toggleConfirmPassword();
                                },
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Password is required';
                                  } else if (value.trim().length < 8) {
                                    return "Password must be 8 characters long";
                                  } else if (passwordTextController.text !=
                                      confirmPasswordTextController.text) {
                                    return "Password doesn't match";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.ch),
                              BlocConsumer<SignupCubit, SignupState>(
                                listener: (context, state) {
                                  if (state.signupStatus == SignupStatus.success &&
                                      state.isGoogleLoading == false &&
                                      state.isFromGoogle == false) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteManager.signupConfirmation,
                                    );
                                  } else if (state.signupStatus == SignupStatus.success &&
                                      state.isFromGoogle == true) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteManager.home,
                                      (route) => false,
                                    );
                                  } else if (state.signupStatus == SignupStatus.failed) {
                                    context.showSnackBar(state.errorMsg);
                                  }
                                },
                                builder: (context, state) {
                                  return PrimaryButton.gradient(
                                    title: 'Sign Up',
                                    isLoading:
                                        state.signupStatus == SignupStatus.loading &&
                                        !state.isGoogleLoading,
                                    enableShrinkAnimation: false,
                                    onTap: () {
                                      bool isFormValidated =
                                          _formKey.currentState?.validate() == true;
                                      if (isFormValidated) {
                                        context.closeKeyboard();
                                        final fullName = fullNameController.text;
                                        final email = emailController.text.toLowerCase().trim();
                                        final password = passwordTextController.text.trim();
                                        context.read<SignupCubit>().signup(
                                          fullName,
                                          email,
                                          password,
                                        );
                                      }
                                    },
                                    fontWeight: FontWeight.bold,
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
                                    if (!state.errorMsg.contains('cancelled by the user')) {
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
                                  // context.read<LoginCubit>().loginWithGoogle();
                                },
                              ),
                              SizedBox(height: 8.ch),
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
                                      padding: EdgeInsets.only(
                                        left: 4.cw,
                                        right: 4.cw,
                                        top: 8.ch,
                                        bottom: 8.ch,
                                      ),
                                      child: Text(
                                        'Login',
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
                        );
                      },
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
