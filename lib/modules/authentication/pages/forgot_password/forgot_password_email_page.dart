import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/modules/authentication/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:mywords/utils/extensions/email_validator.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() => _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ForgotPasswordCubit>().resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Forgot Password?'),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your registered email address below. We'll send you a one-time passcode (OTP) to reset your password.",
                  style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 26),
                Text('Your Registered Email', style: context.textTheme.titleMedium),
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
                SizedBox(height: 20),
                BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state.step == ForgotPasswordStep.emailInput) {
                      if (state.status == ForgotPasswordStatus.success) {
                        Navigator.pushReplacementNamed(context, RouteManager.forgotPasswordOtp);
                      } else if (state.status == ForgotPasswordStatus.failure) {
                        context.showSnackBar(state.errorMessage);
                      }
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton.filled(
                      isLoading: state.step == ForgotPasswordStep.emailInput && state.status == ForgotPasswordStatus.loading,
                      title: 'Send OTP Code',
                      onTap: () {
                        // If left side evaluates to null, and null == true is false
                        bool isFormValidated = _formKey.currentState?.validate() == true;
                        if (isFormValidated) {
                          context.closeKeyboard();
                          final email = emailController.text.toLowerCase().trim();
                          context.read<ForgotPasswordCubit>().submitEmail(email);
                        }
                      },
                      fontWeight: FontWeight.bold,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
