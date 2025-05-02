import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/authentication/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  const ForgotPasswordOtpPage({super.key});

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Enter OTP Code'),
      body: Container(
        margin: EdgeInsets.all(16.cw),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Check your email inbox or spam folder for a one-time passcode (OTP). Enter the code below.",
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 26.ch),
              Pinput(
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                controller: otpController,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onCompleted: (pin) {
                  final otp = pin.trim();
                  context.read<ForgotPasswordCubit>().verifyOtp(otp);
                },
              ),
              SizedBox(height: 26.ch),
              Text("You can resend the code in 56 seconds", style: context.textTheme.bodyMedium),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.ch),
                child: Text(
                  "Resend",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.ch),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state.step == ForgotPasswordStep.otpInput) {
                    if (state.status == ForgotPasswordStatus.success) {
                      Navigator.pushReplacementNamed(context, RouteManager.forgotPasswordReset);
                    } else if (state.status == ForgotPasswordStatus.failure) {
                      context.showSnackBar(state.errorMessage);
                    }
                  }
                },
                builder: (context, state) {
                  return PrimaryButton.filled(
                    title: 'Confirm',
                    isLoading: state.step == ForgotPasswordStep.otpInput && state.status == ForgotPasswordStatus.loading,
                    onTap: () {
                      final otp = otpController.text.trim();
                      if (otp.isEmpty) {
                        context.showSnackBar('Otp is required');
                        return;
                      }
                      context.closeKeyboard();
                      context.read<ForgotPasswordCubit>().verifyOtp(otp);
                    },
                    fontWeight: FontWeight.bold,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

final defaultPinTheme = PinTheme(
  width: 75.cw,
  height: 56.ch,
  textStyle: TextStyle(
    fontSize: 16.csp,
    color: Color.fromRGBO(30, 60, 87, 1),
    fontWeight: FontWeight.w600,
  ),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(10.cr),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: AppColors.accent),
  borderRadius: BorderRadius.circular(10.cr),
);
