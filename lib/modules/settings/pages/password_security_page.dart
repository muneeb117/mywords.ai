import 'package:flutter/material.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class PasswordSecurityPage extends StatelessWidget {
  const PasswordSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return Scaffold(
      appBar: CustomAppBar(title: 'Security'),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            InputField.password(hintText: 'Current password'),
            SizedBox(height: 16),
            Text('Your password needs to be at least 8 characters long.\nInclude some words and phrases to make it even more safer'),
            SizedBox(height: 16),
            InputField.password(hintText: 'New Password'),
            SizedBox(height: 16),
            InputField.password(
              hintText: 'Confirm Your Password',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
        child: PrimaryButton.filled(
          onTap: () {
            // todo :: update password
          },
          title: 'Update',
          backgroundColor: context.colorScheme.secondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
