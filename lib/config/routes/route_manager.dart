import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywords/modules/ai_detector/pages/ai_detector_input_page.dart';
import 'package:mywords/modules/ai_humanizer/pages/ai_humanizer_input_page.dart';
import 'package:mywords/modules/ai_writer/pages/ai_writer_input_page.dart';
import 'package:mywords/modules/authentication/pages/forgot_password/forgot_password_email_page.dart';
import 'package:mywords/modules/authentication/pages/forgot_password/forgot_password_otp_page.dart';
import 'package:mywords/modules/authentication/pages/forgot_password/forgot_password_reset_page.dart';
import 'package:mywords/modules/authentication/pages/forgot_password/forgot_password_success_page.dart';
import 'package:mywords/modules/authentication/pages/login_page.dart';
import 'package:mywords/modules/authentication/pages/signup/enter_otp_signup_page.dart';
import 'package:mywords/modules/authentication/pages/signup/signup_confirmation_page.dart';
import 'package:mywords/modules/authentication/pages/signup/signup_page.dart';
import 'package:mywords/modules/authentication/pages/signup/two_factor_signup_page.dart';
import 'package:mywords/modules/home/pages/home_page.dart';
import 'package:mywords/modules/onboarding/pages/onboarding_page.dart';
import 'package:mywords/modules/settings/pages/change_password/password_security_page.dart';
import 'package:mywords/modules/settings/pages/privacy_policy/privacy_policy_page.dart';
import 'package:mywords/modules/settings/pages/profile/account_settings_page.dart';
import 'package:mywords/modules/settings/pages/settings_page.dart';
import 'package:mywords/modules/startup/pages/splash_page.dart';

class RouteManager {
  // Route names
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String twoFactorSignup = '/twoFactorSignup';
  static const String enterOtpSignup = '/enterOtpSignup';
  static const String signupConfirmation = '/signupConfirmation';
  static const String home = '/home';
  static const String aiWriterInput = '/aiWriterInput';
  static const String aiHumanizerInput = '/aiHumanizerInput';
  static const String aiDetectorInput = '/aiDetectorInput';
  static const String detectorPreference = '/detectorPreference';
  static const String setting = '/setting';
  static const String accountSettings = '/accountSettings';
  static const String passwordSecurity = '/passwordSecurity';
  static const String forgotPasswordEmail = '/forgotPasswordEmail';
  static const String forgotPasswordOtp = '/forgotPasswordOtp';
  static const String forgotPasswordReset = '/forgotPasswordReset';
  static const String forgotPasswordSuccess = '/forgotPasswordSuccess';
  static const String privacyPolicy = '/privacyPolicy';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return CupertinoPageRoute(builder: (_) => const SplashPage());
      case onboarding:
        return CupertinoPageRoute(builder: (_) => OnboardingPage());
      case login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());
      case forgotPasswordEmail:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordEmailPage());
      case forgotPasswordOtp:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordOtpPage());
      case forgotPasswordReset:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordResetPage());
      case forgotPasswordSuccess:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordSuccessPage());
      case signup:
        return CupertinoPageRoute(builder: (_) => const SignupPage());
      case twoFactorSignup:
        return CupertinoPageRoute(builder: (_) => const TwoFactorSignupPage());
      case enterOtpSignup:
        return CupertinoPageRoute(builder: (_) => const EnterOtpSignupPage());
      case signupConfirmation:
        return CupertinoPageRoute(builder: (_) => const SignupConfirmationPage());
      case home:
        return CupertinoPageRoute(builder: (_) => const HomePage());
      case setting:
        return CupertinoPageRoute(builder: (_) => const SettingsPage());
      case accountSettings:
        return CupertinoPageRoute(builder: (_) => const AccountSettingsPage());
      case passwordSecurity:
        return CupertinoPageRoute(builder: (_) => const PasswordSecurityPage());

      /// The [preference] and [output] ai-writer routes are being called with [PageRouteBuilder]
      case aiWriterInput:
        return CupertinoPageRoute(builder: (_) => const AiWriterInputPage());
      case aiHumanizerInput:
        return CupertinoPageRoute(builder: (_) => const AiHumanizerInputPage());
      case aiDetectorInput:
        return CupertinoPageRoute(builder: (_) => const AiDetectorInputPage());
      case privacyPolicy:
        return CupertinoPageRoute(builder: (_) => const PrivacyPolicyPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: const Text('Error')), body: const Center(child: Text('Page not found'))),
    );
  }
}
