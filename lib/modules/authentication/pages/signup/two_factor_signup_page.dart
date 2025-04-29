import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/authentication/widgets/auth_header_widget.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class TwoFactorSignupPage extends StatefulWidget {
  const TwoFactorSignupPage({super.key});

  @override
  State<TwoFactorSignupPage> createState() => _TwoFactorSignupPageState();
}

class _TwoFactorSignupPageState extends State<TwoFactorSignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Padding(padding: const EdgeInsets.only(top: 10.0), child: TopAppIconAndTitleWidget()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two Factor Authentication',
                style: context.textTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 18),
              Text(
                'App requires to protect your account. How would you like to receive your two factor code?',
                style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurface),
              ),
              SizedBox(height: 18),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colorScheme.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/svg/ic_email.svg'),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Send to email", style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(
                          "We'll send the code to\n***ams@yopmail.com",
                          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurface, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 18,
                      width: 18,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: context.colorScheme.secondary),
                      child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              PrimaryButton.filled(
                title: 'Next',
                onTap: () {
                  Navigator.pushReplacementNamed(context, RouteManager.enterOtpSignup);
                },
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
