import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AutoLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const AutoLoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.darkOrangeBg,
              border: Border.all(color: Color(0xffEDF1F3)),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Text('Continue', style: context.textTheme.titleMedium),
        ],
      ),
    );
  }
}
