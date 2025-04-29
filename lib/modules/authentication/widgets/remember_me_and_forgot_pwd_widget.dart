import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class RememberMeAndForgotPasswordTile extends StatefulWidget {
  final VoidCallback onRememberMeTap;
  final VoidCallback onForgotPasswordTap;

  const RememberMeAndForgotPasswordTile({super.key, required this.onRememberMeTap, required this.onForgotPasswordTap});

  @override
  State<RememberMeAndForgotPasswordTile> createState() => _RememberMeAndForgotPasswordTileState();
}

class _RememberMeAndForgotPasswordTileState extends State<RememberMeAndForgotPasswordTile> {
  bool isRememberPasswordEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              isRememberPasswordEnabled = !isRememberPasswordEnabled;
            });
            widget.onRememberMeTap();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 4),
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: context.colorScheme.outline, width: 1.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: isRememberPasswordEnabled ? context.colorScheme.primary : Colors.transparent),
                  ),
                ),
                SizedBox(width: 8),
                Container(child: Text('Remember me', style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onForgotPasswordTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('Forgot Password?', style: context.textTheme.titleMedium),
          ),
        ),
      ],
    );
  }
}
