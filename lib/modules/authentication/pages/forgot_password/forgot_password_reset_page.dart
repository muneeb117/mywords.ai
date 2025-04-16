import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/modules/authentication/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class ForgotPasswordResetPage extends StatefulWidget {
  const ForgotPasswordResetPage({super.key});

  @override
  State<ForgotPasswordResetPage> createState() => _ForgotPasswordResetPageState();
}

class _ForgotPasswordResetPageState extends State<ForgotPasswordResetPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Reset Password'),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose a new password for your AITripBot account. Make sure it's secure and easy to remember.",
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 26),
                Text('New Password', style: context.textTheme.titleMedium),
                SizedBox(height: 8),
                InputField.password(
                  hintText: 'New Password',
                  controller: passwordController,
                  // suffixIconPath: state.isPasswordHidden ? 'assets/images/svg/ic_pwd_hidden.svg' : 'assets/images/svg/ic_pwd_shown.svg',
                  // obscureText: state.isPasswordHidden,
                  obscureText: true,
                  onSuffixIconTap: () {
                    // context.read<SignupCubit>().togglePassword();
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
                Text('Confirm New Password', style: context.textTheme.titleMedium),
                SizedBox(height: 8),
                InputField.password(
                  hintText: 'Confirm New Password',
                  controller: confirmPasswordController,
                  // suffixIconPath: state.isConfirmPasswordHidden
                  //     ? 'assets/images/svg/ic_pwd_hidden.svg'
                  //     : 'assets/images/svg/ic_pwd_shown.svg',
                  // obscureText: state.isConfirmPasswordHidden,
                  obscureText: true,
                  onSuffixIconTap: () {
                    // context.read<SignupCubit>().toggleConfirmPassword();
                  },
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    } else if (value.trim().length < 8) {
                      return "Password must be 8 characters long";
                    } else if (passwordController.text != confirmPasswordController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state.step == ForgotPasswordStep.newPassword) {
                      if (state.status == ForgotPasswordStatus.success) {
                        Navigator.pushReplacementNamed(context, RouteManager.forgotPasswordSuccess);
                      } else if (state.status == ForgotPasswordStatus.failure) {
                        context.showSnackBar(state.errorMessage);
                      }
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton.filled(
                      isLoading: state.step == ForgotPasswordStep.newPassword && state.status == ForgotPasswordStatus.loading,
                      title: 'Save New Password',
                      onTap: () {
                        bool isFormValidated = _formKey.currentState?.validate() == true;
                        if (isFormValidated) {
                          context.closeKeyboard();
                          final password = passwordController.text.trim();
                          context.read<ForgotPasswordCubit>().submitNewPassword(password);
                        }
                      },
                      fontWeight: FontWeight.bold,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
