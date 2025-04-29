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
import 'package:mywords/modules/authentication/widgets/auth_header_widget.dart';
import 'package:mywords/modules/authentication/widgets/google_auth_button.dart';
import 'package:mywords/modules/authentication/widgets/or_divider_widget.dart';
import 'package:mywords/utils/extensions/email_validator.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

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
              (context) => SignupCubit(authRepository: sl(), socialAuthRepository: sl(), sessionRepository: sl(), analyticsService: sl()),
        ),
        BlocProvider(
          create:
              (context) => LoginCubit(authRepository: sl(), sessionRepository: sl(), socialAuthRepository: sl(), analyticsService: sl()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final signupCubit = context.watch<SignupCubit>();
          bool isSigningUpWithGoogle = signupCubit.state.signupStatus == SignupStatus.googleLoading || signupCubit.state.isGoogleLoading;
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  title: Padding(padding: const EdgeInsets.only(top: 10.0), child: TopAppIconAndTitleWidget()),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                                style: context.textTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 16),
                              Text('Full Name', style: context.textTheme.titleMedium),
                              SizedBox(height: 8),
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
                              SizedBox(height: 12),
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
                              InputField.password(
                                hintText: 'Password',
                                controller: passwordTextController,
                                suffixIconPath:
                                    state.isPasswordHidden ? 'assets/images/svg/ic_pwd_hidden.svg' : 'assets/images/svg/ic_pwd_shown.svg',
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
                              SizedBox(height: 12),
                              Text('Confirm Password', style: context.textTheme.titleMedium),
                              SizedBox(height: 8),
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
                                  } else if (passwordTextController.text != confirmPasswordTextController.text) {
                                    return "Password doesn't match";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              BlocConsumer<SignupCubit, SignupState>(
                                listener: (context, state) {
                                  if (state.signupStatus == SignupStatus.success &&
                                      state.isGoogleLoading == false &&
                                      state.isFromGoogle == false) {
                                    Navigator.pushReplacementNamed(context, RouteManager.signupConfirmation);
                                  } else if (state.signupStatus == SignupStatus.success && state.isFromGoogle == true) {
                                    Navigator.pushNamedAndRemoveUntil(context, RouteManager.home, (route) => false);
                                  } else if (state.signupStatus == SignupStatus.googleSuccess) {
                                    context.read<SignupCubit>().signup(state.name, state.email, '', provider: 'google');
                                  } else if (state.signupStatus == SignupStatus.failed) {
                                    if (!state.errorMsg.contains('cancelled by the user')) {
                                      context.showSnackBar(state.errorMsg);
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  return PrimaryButton.gradient(
                                    title: 'Sign Up',
                                    isLoading: state.signupStatus == SignupStatus.loading && !state.isGoogleLoading,
                                    enableShrinkAnimation: false,
                                    onTap: () {
                                      bool isFormValidated = _formKey.currentState?.validate() == true;
                                      if (isFormValidated) {
                                        context.closeKeyboard();
                                        final fullName = fullNameController.text;
                                        final email = emailController.text.toLowerCase().trim();
                                        final password = passwordTextController.text.trim();
                                        context.read<SignupCubit>().signup(fullName, email, password);
                                      }
                                    },
                                    fontWeight: FontWeight.bold,
                                  );
                                },
                              ),
                              OrDividerWidget(),
                              GoogleAuthButton(
                                onTap: () {
                                  context.read<SignupCubit>().signupWithGoogle();
                                },
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurface),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, RouteManager.login);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8, bottom: 8),
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
                Container(color: Colors.black.withOpacity(0.15), child: LoadingIndicator(bgColor: AppColors.black)),
            ],
          );
        },
      ),
    );
  }
}
