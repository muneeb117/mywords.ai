
import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class RememberMeAndForgotPasswordTile extends StatelessWidget {
  final VoidCallback onRememberMeTap;
  final VoidCallback onForgotPasswordTap;

  const RememberMeAndForgotPasswordTile({
    super.key,
    required this.onRememberMeTap,
    required this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onRememberMeTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 4),
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colorScheme.outline,
                      width: 1.6,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  child: Text(
                    'Remember me',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onForgotPasswordTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Forgot Password?',
              style: context.textTheme.titleMedium,
            ),
          ),
        )
      ],
    );
  }
}
